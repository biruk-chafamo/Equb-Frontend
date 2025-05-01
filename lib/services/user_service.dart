import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class UserService {
  final String baseUrl;
  final Dio dio;

  const UserService({required this.baseUrl, required this.dio});

  Future<List<dynamic>> getUsersByName(String name) async {
    final response = await dio.get(
      '$baseUrl/users/search/?name=$name',
    );
    if (response.statusCode == 200) {
      return response.data['results'];
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<Map<String, dynamic>> getUser(int id) async {
    final response = await dio.get(
      '$baseUrl/users/$id/',
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await dio.get(
      '$baseUrl/users/currentuser/',
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  Future<Map<String, dynamic>> updateProfilePicture(
      int id, PlatformFile profilePicture) async {
    MultipartFile multipartFile;

    if (kIsWeb) {
      multipartFile = MultipartFile.fromBytes(
        profilePicture.bytes!,
        filename: profilePicture.name,
        contentType: MediaType('image', 'jpeg'),
      );
    } else {
      multipartFile = await MultipartFile.fromFile(
        profilePicture.path!,
        filename: profilePicture.name,
        contentType: MediaType('image', 'jpeg'),
      );
    }
    final formData = FormData.fromMap({
      'profile_picture': multipartFile,
    });

    final response = await dio.patch(
      '$baseUrl/users/$id/',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      return response.data;
    } else {
      throw Exception('Failed to update profile picture');
    }
  }
}
