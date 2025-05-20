import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

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
    int id,
    PickedImage pickedImage,
  ) async {
    final multipartFile = MultipartFile.fromBytes(
      pickedImage.bytes,
      filename: pickedImage.name,
      contentType: MediaType('image', 'jpeg'),
    );

    final formData = FormData.fromMap({
      'profile_picture': multipartFile,
    });

    final response = await dio.patch(
      '$baseUrl/users/$id/',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      return response.data;
    } else {
      throw Exception('Failed to update profile picture');
    }
  }

  Future<Uint8List?> getProfilePicture(String? awsS3imageURL) async {
    if (awsS3imageURL == null || awsS3imageURL.isEmpty) {
      debugPrint('Image URL cannot be null or empty');
      return null;
    }
    try {
      final s3ImagePath = awsS3imageURL.split('.com/')[1];
      final cloudFrontUrl = 'https://d2h65mrnusp89a.cloudfront.net/$s3ImagePath';
      final response = await http.get(Uri.parse(cloudFrontUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        debugPrint('Failed to load image (HTTP ${response.statusCode})');
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
