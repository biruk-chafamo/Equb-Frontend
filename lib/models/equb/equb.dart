import 'package:equb_v3_frontend/models/authentication/user.dart';

class Equb {
  final String name;
  final double capacity;
  final int maxMembers;
  final String cycle;
  final int currentRound;
  final String creationDate;
  final bool isPrivate;
  final bool isActive;
  final bool isCompleted;
  final List<User> members;

  const Equb({
    required this.name,
    required this.capacity,
    required this.maxMembers,
    required this.cycle,
    required this.currentRound,
    required this.creationDate,
    required this.isPrivate,
    required this.isActive,
    required this.isCompleted,
    required this.members,
  });

  factory Equb.fromJson(Map<String, dynamic> json) {
    return Equb(
      name: json['name'],
      capacity: json['capacity'],
      maxMembers: json['maxMembers'],
      cycle: json['cycle'],
      currentRound: json['currentRound'],
      creationDate: json['creationDate'],
      isPrivate: json['isPrivate'],
      isActive: json['isActive'],
      isCompleted: json['isCompleted'],
      members: json['members'],
    );
  }
}
