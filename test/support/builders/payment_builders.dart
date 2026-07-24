import 'package:equb_v3_frontend/models/payment_confirmation_request/payment_confirmation_request.dart';
import 'package:equb_v3_frontend/models/payment_method/payment_method.dart';
import 'package:equb_v3_frontend/models/user/user.dart';

import 'user_builder.dart';

PaymentConfirmationRequest buildPaymentConfirmationRequest({
  int id = 1,
  User? sender,
  int round = 1,
  PaymentMethod? paymentMethod,
  String message = '',
  bool isAccepted = false,
  DateTime? creationDate,
}) {
  return PaymentConfirmationRequest(
    id: id,
    sender: sender ?? buildUser(id: 1),
    round: round,
    paymentMethod: paymentMethod ?? buildPaymentMethod(),
    message: message,
    isAccepted: isAccepted,
    creationDate: creationDate ?? DateTime(2026, 3, 1),
  );
}
