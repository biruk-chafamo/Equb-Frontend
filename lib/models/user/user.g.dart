// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSummary _$UserSummaryFromJson(Map<String, dynamic> json) => UserSummary(
      id: (json['id'] as num).toInt(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      score: double.parse(json['score'] as String),
      profilePictureUrl: json['profile_picture'] as String?,
    );

Map<String, dynamic> _$UserSummaryToJson(UserSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'score': instance.score,
      'profile_picture': instance.profilePictureUrl,
    };

WinnerUser _$WinnerUserFromJson(Map<String, dynamic> json) => WinnerUser(
      id: (json['id'] as num).toInt(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      score: double.parse(json['score'] as String),
      profilePictureUrl: json['profile_picture'] as String?,
      paymentMethods: (json['selected_payment_methods'] as List<dynamic>)
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WinnerUserToJson(WinnerUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'score': instance.score,
      'profile_picture': instance.profilePictureUrl,
      'selected_payment_methods': instance.paymentMethods,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      score: double.parse(json['score'] as String),
      paymentMethods: (json['selected_payment_methods'] as List<dynamic>)
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      friends: (json['friends'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      joinedEqubIds: (json['joined_equbs'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      profilePictureUrl: json['profile_picture'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'score': instance.score,
      'profile_picture': instance.profilePictureUrl,
      'username': instance.username,
      'selected_payment_methods': instance.paymentMethods,
      'friends': instance.friends,
      'joined_equbs': instance.joinedEqubIds,
    };
