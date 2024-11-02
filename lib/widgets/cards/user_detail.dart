import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/widgets/buttons/user_avatar_button.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatelessWidget {
  final User user;
  final Widget? detail1;
  final Widget? detail2;
  final Widget? detail3;

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
              Container(
                constraints: const BoxConstraints(maxWidth: 120), 
                child: Text(
                  '${user.firstName} ${user.lastName}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              StarRating(
                rating: user.score,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
              detail1 ?? const SizedBox(),
              detail2 ?? const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating; // Rating should be between 0.0 and 5.0
  final double starSize;
  final Color color;

  const StarRating({
    super.key,
    required this.rating,
    this.starSize = 12.0,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    // Loop through 5 stars
    for (int i = 1; i <= 5; i++) {
      if (i <= rating) {
        // Full star
        stars.add(Icon(Icons.star, color: color, size: starSize));
      } else if (i - rating < 1) {
        // Half star
        stars.add(Icon(Icons.star_half, color: color, size: starSize));
      } else {
        // Empty star
        stars.add(Icon(Icons.star_border, color: color, size: starSize));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }
}
