import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class SectionTitleTile extends StatelessWidget {
  final String title;
  final IconData titleIconData;
  final Widget trailingButton;

  const SectionTitleTile(
    this.title,
    this.titleIconData,
    this.trailingButton, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Text titleText = Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
    );
    return Container(
      padding: AppPadding.globalPadding,
      margin: AppMargin.globalMargin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                titleIconData,
                color: AppColors.onTertiary,
              ),
              const SizedBox(width: 5),
              titleText,
            ],
          ),
          trailingButton,
        ],
      ),
    );
  }
}
