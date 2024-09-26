import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class BoarderedTile extends StatelessWidget {
  final Widget leadingWidget;
  final Widget trailingButton;
  final Function()? onTap;

  const BoarderedTile(
    this.leadingWidget,
    this.trailingButton, {
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.globalPadding,
      margin: AppMargin.globalMargin,
      decoration: PrimaryBoxDecor(),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leadingWidget,
            const SizedBox(width: 10),
            trailingButton,
          ],
        ),
      ),
    );
  }
}
