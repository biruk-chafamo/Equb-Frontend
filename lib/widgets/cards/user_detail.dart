import 'package:equb_v3_frontend/models/authentication/user.dart';
import 'package:equb_v3_frontend/widgets/buttons/user_avatar_button.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatelessWidget {
  final User user;
  final String? detail1;
  final String? detail2;
  final String? detail3;

  const UserDetail(
    this.user, {
    this.detail1,
    this.detail2,
    this.detail3,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          UserAvatarButton(user),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.firstName} ${user.lastName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...[detail1, detail2, detail3]
                  .where((detail) => detail != null)
                  .map(
                    (detail) => Text(
                      detail!,
                      style: Theme.of(context).textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            ],
          )
        ],
      ),
    );
  }
}
