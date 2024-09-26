import 'package:dio/dio.dart';

class PaymentConfirmationRequestService {
  final String baseUrl;
  final Dio dio;

  PaymentConfirmationRequestService({required this.baseUrl, required this.dio});

  Future<Map<String, dynamic>> createPaymentConfirmationRequest(
      int equbId, int paymentMethodId, int round, String message) async {
    final response = await dio.post(
      '$baseUrl/paymentconfirmationrequest/',
      data: {
        'equb': '$baseUrl/equbs/$equbId/',
        'payment_method': '$baseUrl/paymentmethods/$paymentMethodId/',
        'round': '$round',
        'message': message,
      },
      options: Options(
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ),
    );
    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception(
          'Failed to creat payment confirmation request for equb id: $equbId');
    }
  }

  Future<List<dynamic>> getPaymentConfirmationRequests(
      int equbId, int round) async {
    final response = await dio.get(
      '$baseUrl/paymentconfirmationrequest/by-equb-round/?equb=$equbId&round=$round',
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load payment confirmation requests');
    }
  }

  Future<Map<String, dynamic>> acceptPaymentConfirmationRequest(
      int paymentConfirmationRequestId) async {
    final response = await dio.put(
      '$baseUrl/paymentconfirmationrequest/$paymentConfirmationRequestId/',
      data: {
        'is_accepted': 'true',
      },
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to accept payment confirmation request');
    }
  }

  Future<Map<String, dynamic>> rejectPaymentConfirmationRequest(
      int paymentConfirmationRequestId) async {
    final response = await dio.put(
      '$baseUrl/paymentconfirmationrequest/$paymentConfirmationRequestId/',
      data: {
        'is_rejected': 'true',
      },
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to reject payment confirmation request');
    }
  }
}
