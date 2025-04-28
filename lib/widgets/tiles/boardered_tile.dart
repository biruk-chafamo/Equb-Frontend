import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class BoarderedTile extends StatelessWidget {
  final Widget leadingWidget;
  final Widget trailingButton;
  final Function()? onTap;
  final Widget? bottomWidget;

  const BoarderedTile(
    this.leadingWidget,
    this.trailingButton, {
    this.bottomWidget,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
