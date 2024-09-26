import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'friend_request.g.dart';

@JsonSerializable()
class FriendRequest {
  //['id', 'url', 'sender', 'receiver', 'equb', 'round', 'payment_method', 'message']
  final int id;
  final User sender;
  final User receiver;
  @JsonKey(name: 'is_accepted')
  final bool isAccepted;
  @JsonKey(name: 'creation_date', fromJson: DateTime.parse)
  final DateTime creationDate;

  FriendRequest({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.isAccepted,
    required this.creationDate,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return _$FriendRequestFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FriendRequestToJson(this);

  FriendRequest copyWith({bool? isAccepted}) {
    return FriendRequest(
      id: id,
      sender: sender,
      receiver: receiver,
      isAccepted: isAccepted ?? this.isAccepted,
      creationDate: creationDate,
    );
  }
}
