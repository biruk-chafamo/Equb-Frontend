// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
      profilePicture: json['profile_picture'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'score': instance.score,
      'selected_payment_methods': instance.paymentMethods,
      'friends': instance.friends,
      'joined_equbs': instance.joinedEqubIds,
      'profile_picture': instance.profilePicture,
    };
