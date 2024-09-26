import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/models/payment_method/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_confirmation_request.g.dart';

@JsonSerializable()
class PaymentConfirmationRequest {
  //['id', 'url', 'sender', 'receiver', 'equb', 'round', 'payment_method', 'message']
  final int id;
  final User sender;
  final int round;
  @JsonKey(name: 'payment_method')
  final PaymentMethod paymentMethod;
  final String message;
  @JsonKey(name: 'is_accepted')
  final bool isAccepted;
  @JsonKey(name: 'creation_date', fromJson: DateTime.parse)
  final DateTime creationDate;

  PaymentConfirmationRequest({
    required this.id,
    required this.sender,
    required this.round,
    required this.paymentMethod,
    required this.message,
    required this.isAccepted,
    required this.creationDate,
  });

  factory PaymentConfirmationRequest.fromJson(Map<String, dynamic> json) {
    return _$PaymentConfirmationRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PaymentConfirmationRequestToJson(this);

  PaymentConfirmationRequest copyWith({bool? isAccepted}) {
    return PaymentConfirmationRequest(
      id: id,
      sender: sender,
      round: round,
      paymentMethod: paymentMethod,
      message: message,
      isAccepted: isAccepted ?? this.isAccepted,
      creationDate: creationDate,
    );
  }
}
