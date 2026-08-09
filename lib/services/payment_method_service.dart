import 'package:dio/dio.dart';

class PaymentMethodService {
  final String baseUrl;
  final Dio dio;

  PaymentMethodService({required this.baseUrl, required this.dio});

  Future<Map<String, dynamic>> createPaymentMethod(
      String service, String detail) async {
    final response = await dio.post(
      '$baseUrl/paymentmethods/',
      data: {'service': service, 'detail': detail},
      options: Options(
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ),
    );
    return response.data;
  }

  Future<List<dynamic>> getPaymentMethods() async {
    final response = await dio.get(
      '$baseUrl/paymentmethods/',
    );
    return response.data;
  }

  Future<List<dynamic>> getPaymentMethodsByUser(int userId) async {
    final response = await dio.get(
      '$baseUrl/paymentmethods/by-user/?user=$userId',
    );
    return response.data;
  }

  Future<Map<String, dynamic>> removePaymentMethod(int paymentMethodId) async {
    final response = await dio.delete(
      '$baseUrl/paymentmethod/$paymentMethodId/',
      data: {
        'is_rejected': 'true',
      },
    );
    return response.data;
  }

  Future<List<dynamic>> getServices() async {
    final response = await dio.get(
      '$baseUrl/paymentmethods/services/',
    );
    return response.data;
  }
}
