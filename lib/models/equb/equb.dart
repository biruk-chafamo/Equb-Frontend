import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'equb.g.dart';

@JsonSerializable()
class Equb {
  final int id;
  final String name;
  @JsonKey(fromJson: double.parse)
  final double amount;
  @JsonKey(name: 'max_members')
  final int maxMembers;
  final String cycle;
  @JsonKey(name: 'current_round')
  final int currentRound;
  @JsonKey(name: 'creation_date')
  final String creationDate;
  @JsonKey(name: 'is_private')
  final bool isPrivate;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @JsonKey(name: 'is_in_payment_stage')
  final bool isInPaymentStage;
  final List<User> members;

  const Equb({
    required this.id,
    required this.name,
    required this.amount,
    required this.maxMembers,
    required this.cycle,
    required this.currentRound,
    required this.creationDate,
    required this.isPrivate,
    required this.isActive,
    required this.isCompleted,
    required this.isInPaymentStage,
    required this.members,
  });

  factory Equb.fromJson(Map<String, dynamic> json) => _$EqubFromJson(json);

  Map<String, dynamic> toJson() => _$EqubToJson(this);
}

class EqubCreationDTO {
  final String name;
  final double amount;
  final int maxMembers;
  final String cycle;
  final bool isPrivate;

  EqubCreationDTO({
    required this.name,
    required this.amount,
    required this.maxMembers,
    required this.cycle,
    required this.isPrivate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'max_members': maxMembers,
      'cycle': cycle,
      'is_private': isPrivate,
    };
  }

  @override
  String toString() {
    final rpr = 'name: $name'
        'amount: $amount'
        'max_members: $maxMembers'
        'cycle: $cycle'
        'is_private: $isPrivate';
    return rpr;
  }
}
