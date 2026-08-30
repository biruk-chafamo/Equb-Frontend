import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/repositories/user_repository.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../builders/user_builder.dart';

class FakeUserRepository extends Fake implements UserRepository {
  final List<String> calls = [];

  List<User> searchResult = const [];
  User? currentUser;
  User Function(int id) userResult = (id) => buildUser(id: id);
  User? updateProfilePictureResult;
  ImageProvider profilePictureResult =
      const AssetImage(defaultAvatarImagePath);

  Object? nextError;

  void _maybeThrow() {
    final error = nextError;
    if (error != null) {
      nextError = null;
      throw error;
    }
  }

  @override
  Future<List<User>> getUsersByName(String name) async {
    calls.add('getUsersByName($name)');
    _maybeThrow();
    return searchResult;
  }

  @override
  Future<User> getUser(int id) async {
    calls.add('getUser($id)');
    _maybeThrow();
    return userResult(id);
  }

  @override
  Future<User> getCurrentUser() async {
    calls.add('getCurrentUser()');
    _maybeThrow();
    return currentUser ?? buildUser();
  }

  @override
  Future<User> updateProfilePicture(int id, PickedImage pickedImage) async {
    calls.add('updateProfilePicture($id, ${pickedImage.name})');
    _maybeThrow();
    return updateProfilePictureResult ?? userResult(id);
  }
}
