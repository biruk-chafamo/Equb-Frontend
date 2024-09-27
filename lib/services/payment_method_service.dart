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
    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to creat payment method');
    }
  }

  Future<List<dynamic>> getPaymentMethods() async {
    final response = await dio.get(
      '$baseUrl/paymentmethods/',
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load payment methods for current user');
    }
  }

  Future<List<dynamic>> getPaymentMethodsByUser(int userId) async {
    final response = await dio.get(
      '$baseUrl/paymentmethods/by-user/?user=$userId',
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load payment methods for user: $userId');
    }
  }

  Future<Map<String, dynamic>> removePaymentMethod(int paymentMethodId) async {
    final response = await dio.delete(
      '$baseUrl/paymentmethod/$paymentMethodId/',
      data: {
        'is_rejected': 'true',
      },
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to remove payment method');
    }
  }

  Future<List<dynamic>> getServices() async {
    final response = await dio.get(
      '$baseUrl/paymentmethods/services/',
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load services');
    }
  }
}
