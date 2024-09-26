// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_confirmation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentConfirmationRequest _$PaymentConfirmationRequestFromJson(
        Map<String, dynamic> json) =>
    PaymentConfirmationRequest(
      id: (json['id'] as num).toInt(),
      sender: User.fromJson(json['sender'] as Map<String, dynamic>),
      round: (json['round'] as num).toInt(),
      paymentMethod: PaymentMethod.fromJson(
          json['payment_method'] as Map<String, dynamic>),
      message: json['message'] as String,
      isAccepted: json['is_accepted'] as bool,
      creationDate: DateTime.parse(json['creation_date'] as String),
    );

Map<String, dynamic> _$PaymentConfirmationRequestToJson(
        PaymentConfirmationRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'round': instance.round,
      'payment_method': instance.paymentMethod,
      'message': instance.message,
      'is_accepted': instance.isAccepted,
      'creation_date': instance.creationDate.toIso8601String(),
    };
