import 'package:equb_v3_frontend/models/payment_method/payment_method.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String username;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(fromJson: double.parse)
  final double score;
  @JsonKey(name: 'selected_payment_methods')
  final List<PaymentMethod> paymentMethods;
  final List<int> friends;
  @JsonKey(name: 'joined_equbs')
  final List<int> joinedEqubIds;

  const User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.score,
    required this.paymentMethods,
    required this.friends,
    required this.joinedEqubIds,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class UserDTO {
  final String username;
  final String password;
  final String password2;
  final String firstName;
  final String lastName;
  final String email;

  UserDTO({
    required this.username,
    required this.password,
    required this.password2,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'password2': password2,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }
}

class UserWithTrustStatus {
  final User user;
  final TrustStatus trustStatus;

  UserWithTrustStatus({
    required this.user,
    required this.trustStatus,
  });
}

class UserWithInviteStatus {
  final User user;
  final InviteStatus inviteStatus;

  UserWithInviteStatus({
    required this.user,
    required this.inviteStatus,
  });
}