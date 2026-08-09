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
    return response.data;
  }

  Future<List<dynamic>> getPaymentConfirmationRequests(
      int equbId, int round) async {
    final response = await dio.get(
      '$baseUrl/paymentconfirmationrequest/by-equb-round/?equb=$equbId&round=$round',
    );
    return response.data;
  }

  Future<Map<String, dynamic>> acceptPaymentConfirmationRequest(
      int paymentConfirmationRequestId) async {
    final response = await dio.put(
      '$baseUrl/paymentconfirmationrequest/$paymentConfirmationRequestId/',
      data: {
        'is_accepted': 'true',
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> rejectPaymentConfirmationRequest(
      int paymentConfirmationRequestId) async {
    final response = await dio.put(
      '$baseUrl/paymentconfirmationrequest/$paymentConfirmationRequestId/',
      data: {
        'is_rejected': 'true',
      },
    );
    return response.data;
  }
}
