import 'package:equb_v3_frontend/models/payment_method/payment_method.dart';
import 'package:equb_v3_frontend/models/user/user.dart';

User buildUser({
  int id = 1,
  String? username,
  String firstName = 'Abel',
  String lastName = 'Tesfaye',
  double score = 4.5,
  List<PaymentMethod>? paymentMethods,
  List<int>? friends,
  List<int>? joinedEqubIds,
  String? profilePictureUrl,
}) {
  return User(
    id: id,
    username: username ?? 'user$id',
    firstName: firstName,
    lastName: lastName,
    score: score,
    paymentMethods: paymentMethods ?? const [],
    friends: friends ?? const [],
    joinedEqubIds: joinedEqubIds ?? const [],
    profilePictureUrl: profilePictureUrl,
  );
}

/// A user as they appear nested in another resource.
UserSummary buildUserSummary({
  int id = 1,
  String firstName = 'Abel',
  String lastName = 'Tesfaye',
  double score = 4.5,
  String? profilePictureUrl,
}) {
  return UserSummary(
    id: id,
    firstName: firstName,
    lastName: lastName,
    score: score,
    profilePictureUrl: profilePictureUrl,
  );
}

WinnerUser buildWinnerUser({
  int id = 1,
  String firstName = 'Abel',
  String lastName = 'Tesfaye',
  double score = 4.5,
  List<PaymentMethod>? paymentMethods,
  String? profilePictureUrl,
}) {
  return WinnerUser(
    id: id,
    firstName: firstName,
    lastName: lastName,
    score: score,
    paymentMethods: paymentMethods ?? const [],
    profilePictureUrl: profilePictureUrl,
  );
}

PaymentMethod buildPaymentMethod({
  int id = 1,
  String service = 'Cash',
  String detail = '',
}) {
  return PaymentMethod(id: id, service: service, detail: detail);
}
