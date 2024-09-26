import 'package:equb_v3_frontend/models/payment_method/payment_method.dart';
import 'package:equb_v3_frontend/services/payment_method_service.dart';

class PaymentMethodRepository {
  final PaymentMethodService paymentMethodService;

  PaymentMethodRepository({required this.paymentMethodService});

  Future<PaymentMethod> createPaymentMethod(
      String service, String detail) async {
    final paymentConfirmationRequestJson =
        await paymentMethodService.createPaymentMethod(
      service,
      detail,
    );

    return PaymentMethod.fromJson(paymentConfirmationRequestJson);
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    final paymentConfirmationRequestJsons =
        await paymentMethodService.getPaymentMethods();

    return paymentConfirmationRequestJsons
        .map(
          (dynamic item) => PaymentMethod.fromJson(item),
        )
        .toList();
  }

  Future<List<PaymentMethod>> getPaymentMethodsByUser(int userId) async {
    final paymentConfirmationRequestJsons =
        await paymentMethodService.getPaymentMethodsByUser(userId);

    return paymentConfirmationRequestJsons
        .map(
          (dynamic item) => PaymentMethod.fromJson(item),
        )
        .toList();
  }

  Future<List<String>> getServices() async {
    final servicesJson = await paymentMethodService.getServices();
    return servicesJson.map((dynamic item) {
      return item.toString();
    }).toList();
  }
}
