import 'package:equb_v3_frontend/models/payment_method/payment_method.dart';
import 'package:equb_v3_frontend/repositories/payment_method_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../builders/user_builder.dart';

class FakePaymentMethodRepository extends Fake
    implements PaymentMethodRepository {
  final List<String> calls = [];

  List<PaymentMethod> paymentMethodsResult = const [];
  List<PaymentMethod> paymentMethodsByUserResult = const [];
  List<String> servicesResult = const ['Cash', 'Venmo'];
  PaymentMethod? createResult;

  Object? nextError;

  void _maybeThrow() {
    final error = nextError;
    if (error != null) {
      nextError = null;
      throw error;
    }
  }

  @override
  Future<PaymentMethod> createPaymentMethod(
      String service, String detail) async {
    calls.add('create($service, $detail)');
    _maybeThrow();
    return createResult ?? buildPaymentMethod(service: service, detail: detail);
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods() async {
    calls.add('getPaymentMethods()');
    _maybeThrow();
    return paymentMethodsResult;
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethodsByUser(int userId) async {
    calls.add('getPaymentMethodsByUser($userId)');
    _maybeThrow();
    return paymentMethodsByUserResult;
  }

  @override
  Future<List<String>> getServices() async {
    calls.add('getServices()');
    _maybeThrow();
    return servicesResult;
  }
}
