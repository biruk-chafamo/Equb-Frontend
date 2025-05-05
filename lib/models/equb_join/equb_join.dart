import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'equb_join.g.dart';

@JsonSerializable()
class EqubJoin {
  // ['id', 'equb', 'is_expired']
  final int id;
  @JsonKey(name: 'equb')
  final EqubDetail equbDetail;
  final User receiver;
  @JsonKey(name: 'is_accepted')
  final bool isAccepted;
  @JsonKey(name: 'is_rejected')
  final bool isRejected;
  @JsonKey(name: 'creation_date', fromJson: DateTime.parse)
  final DateTime creationDate;

  EqubJoin({
    required this.id,
    required this.equbDetail,
    required this.receiver,
    required this.isAccepted,
    required this.isRejected,
    required this.creationDate,
  });

  factory EqubJoin.fromJson(Map<String, dynamic> json) {
    return _$EqubJoinFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EqubJoinToJson(this);

  EqubJoin copyWith({bool? isAccepted, bool? isRejected}) {
    return EqubJoin(
      id: id,
      equbDetail: equbDetail,
      receiver: receiver,
      isAccepted: isAccepted ?? this.isAccepted,
      isRejected: isRejected ?? this.isRejected,
      creationDate: creationDate,
    );
  }
}
