import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/user_avatar_button.dart';
import 'package:flutter/material.dart';

const int maxUsersToShow = 3;

class OverlappingAvatars extends StatelessWidget {
  final List<UserSummary> users;
  final int maxToShow;
  final double radius;
  final double fontSize;
  final void Function()? onOverflowTap;

  const OverlappingAvatars(
    this.users, {
    this.maxToShow = maxUsersToShow,
    this.radius = 25,
    this.fontSize = 12,
    this.onOverflowTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final shown = users.length > maxToShow ? maxToShow : users.length;
    final overflow = users.length - shown;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...users.sublist(0, shown).map((user) => Align(
              widthFactor: 0.8,
              child: UserAvatarButton(user, radius: radius, fontSize: fontSize),
            )),
        if (overflow > 0)
          InkWell(
            onTap: onOverflowTap,
            child: Container(
              height: radius * 2,
              width: radius * 2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondaryContainer,
                border: Border.all(
                    color: AppColors.onPrimary.withValues(alpha: 0.3)),
              ),
              child: Text(
                '+$overflow',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: radius * 0.6,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}
