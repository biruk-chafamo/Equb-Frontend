import 'package:equb_v3_frontend/models/friendship/friend_request.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/services/user_service.dart';

class UserRepository {
  final UserService userService;

  const UserRepository({required this.userService});

  Future<List<User>> getUsersByName(String name) async {
    final userJson = await userService.getUsersByName(name);

    return userJson.map((dynamic item) => User.fromJson(item)).toList();
  }

  Future<User> getUser(int id) async {
    final userJson = await userService.getUser(id);

    return User.fromJson(userJson);
  }

  Future<FriendRequest> sendFriendRequest(int receiverId) async {
    final friendRequestJson = await userService.sendFriendRequest(receiverId);

    return FriendRequest.fromJson(friendRequestJson);
  }

  Future<User> getCurrentUser() async {
    final userJson = await userService.getCurrentUser();

    return User.fromJson(userJson);
     
  }
}
