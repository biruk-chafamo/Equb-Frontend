import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/services/user_service.dart';
import 'package:flutter/material.dart';

class UserRepository {
  final UserService userService;
  final Map<int, ImageProvider> _profilePicturesCache = {};

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

    _profilePicturesCache[id] = MemoryImage(pickedImage.bytes);

    return User.fromJson(userJson);
  }

  Future<ImageProvider> getProfilePicture(String? url, int userId) async {
    // return default avatar image if empty or null
    if (url == null || url.isEmpty) {
      return const AssetImage('assets/images/default_avatar.jpg');
    }

    // cache hit
    if (_profilePicturesCache.containsKey(userId)) {
      return _profilePicturesCache[userId]!;
    }

    // cache miss, fetch the image and cache it
    final image = await userService.getProfilePicture(url);
    if (image == null) {
      return const AssetImage('assets/images/default_avatar.jpg');
    }
    _profilePicturesCache[userId] = MemoryImage(image);
    return _profilePicturesCache[userId]!;
  }
}
