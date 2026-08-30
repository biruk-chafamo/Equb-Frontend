import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:http_parser/http_parser.dart';

class UserService {
  final String baseUrl;
  final Dio dio;

  const UserService({required this.baseUrl, required this.dio});

  Future<List<dynamic>> getUsersByName(String name) async {
    final response = await dio.get(
      '$baseUrl/users/search/?name=$name',
    );
    return response.data['results'];
  }

  Future<Map<String, dynamic>> getUser(int id) async {
    final response = await dio.get(
      '$baseUrl/users/$id/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await dio.get(
      '$baseUrl/users/currentuser/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>> updateProfilePicture(
    int id,
    PickedImage pickedImage,
  ) async {
    final extension = pickedImage.name.split('.').last.toLowerCase();
    final multipartFile = MultipartFile.fromBytes(
      pickedImage.bytes,
      filename: pickedImage.name,
      contentType: MediaType('image', extension == 'png' ? 'png' : 'jpeg'),
    );

    final formData = FormData.fromMap({
      'profile_picture': multipartFile,
    });

    final response = await dio.patch(
      '$baseUrl/users/$id/',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return response.data;
  }
}
