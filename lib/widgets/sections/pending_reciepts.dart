import 'package:equb_v3_frontend/models/authentication/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_circle_button.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/cards/user_detail.dart';
import 'package:equb_v3_frontend/widgets/tiles/boardered_tile.dart';
import 'package:flutter/material.dart';

class PendingReciepts extends StatelessWidget {
  final List<User>? pendingUsers;
  const PendingReciepts(this.pendingUsers, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, idx) {
            User? user = pendingUsers?[idx];

            if (user != null) {
              return BoarderedTile(
                UserDetail(user),
                const CustomCircleButton(
                  radius: 10,
                  showBorder: false,
                  child: Icon(Icons.circle_outlined),
                ),
              );
            } else {
              return const Text("");
            }
          },
        ),
        const Padding(
          padding: AppPadding.globalPadding,
          child: CustomElevatedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("See all requests"),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        )
      ],
    );
  }
}
