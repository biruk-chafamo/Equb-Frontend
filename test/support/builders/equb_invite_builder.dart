import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/models/equb_invite/equb_invite.dart';
import 'package:equb_v3_frontend/models/user/user.dart';

import 'equb_builder.dart';
import 'user_builder.dart';

EqubInvite buildEqubInvite({
  int id = 1,
  EqubDetail? equbDetail,
  User? receiver,
  bool isAccepted = false,
  bool isRejected = false,
  DateTime? creationDate,
}) {
  return EqubInvite(
    id: id,
    equbDetail: equbDetail ?? buildEqubDetail(),
    receiver: receiver ?? buildUser(id: 2),
    isAccepted: isAccepted,
    isRejected: isRejected,
    creationDate: creationDate ?? DateTime(2026, 3, 1),
  );
}
