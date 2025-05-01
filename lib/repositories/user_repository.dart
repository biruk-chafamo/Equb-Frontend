import 'package:equb_v3_frontend/models/friendship/friend_request.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/services/user_service.dart';
import 'package:file_picker/file_picker.dart';

class UserRepository {
  final UserService userService;

  const UserRepository({required this.userService});

  Future<List<User>> getUsersByName(String name) async {
    if (name == "") {
      return [];
    }

    final userJson = await userService.getUsersByName(name);
    return userJson.map((dynamic item) => User.fromJson(item)).toList();
  }

  Future<User> getUser(int id) async {
    final userJson = await userService.getUser(id);

    return User.fromJson(userJson);
  }

  Future<User> getCurrentUser() async {
    final userJson = await userService.getCurrentUser();

    return User.fromJson(userJson);
  }

  Future<User> updateProfilePicture(int id, PlatformFile profilePicture) async {
    final userJson = await userService.updateProfilePicture(id, profilePicture);

    return User.fromJson(userJson);
  }
}
