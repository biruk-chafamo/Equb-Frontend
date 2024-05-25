import 'package:equb_v3_frontend/models/authentication/user.dart';
import 'package:equb_v3_frontend/models/equb/equb.dart';

class PaymentStatus {
  final Equb equb;
  final double round;
  final List<User>? paidMembers;
  final List<User>? unpaidMembers;
  final List<User>? confirmationRequestedMembers;
  final List<User>? confirmationReceivedMembers;

  const PaymentStatus({
    required this.equb,
    required this.round,
    required this.paidMembers,
    required this.unpaidMembers,
    required this.confirmationRequestedMembers,
    required this.confirmationReceivedMembers,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    return PaymentStatus(
      equb: Equb.fromJson(json['equb']),
      round: json['round'],
      paidMembers:
          (json['paidMembers'] as List).map((e) => User.fromJson(e)).toList(),
      unpaidMembers:
          (json['unpaidMembers'] as List).map((e) => User.fromJson(e)).toList(),
      confirmationRequestedMembers:
          (json['confirmationRequestedMembers'] as List)
              .map((e) => User.fromJson(e))
              .toList(),
      confirmationReceivedMembers: (json['confirmationReceivedMembers'] as List)
          .map((e) => User.fromJson(e))
          .toList(),
    );
  }
}
