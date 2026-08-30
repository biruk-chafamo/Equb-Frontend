import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/services/user_service.dart';

class UserRepository {
  final UserService userService;

  UserRepository({required this.userService});

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

  Future<User> updateProfilePicture(int id, PickedImage pickedImage) async {
    final userJson = await userService.updateProfilePicture(id, pickedImage);

    return User.fromJson(userJson);
  }
}
