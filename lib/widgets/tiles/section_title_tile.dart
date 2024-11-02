import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class SectionTitleTile extends StatelessWidget {
  final String title;
  final IconData titleIconData;
  final Widget trailingButton;
  final String? description;
  final bool includeDivider;
  final Color? iconColor;
  final double? iconSize;

  const SectionTitleTile(
    this.title,
    this.titleIconData,
    this.trailingButton, {
    this.includeDivider = true,
    this.description,
    super.key,
    this.iconColor,
    this.iconSize,
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
      // margin: AppMargin.globalMargin,
      child: Column(
        children: [
          includeDivider ? Divider(
            color: Theme.of(context)
                .colorScheme
                .onSecondaryContainer
                .withOpacity(includeDivider ? 0.09 : 0),
          ) : const SizedBox(height: 0),
          includeDivider ? const SizedBox(height: 20) : const SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    titleIconData,
                    color: iconColor ?? Theme.of(context).colorScheme.onTertiary,
                    size: iconSize ?? 20,
                  ),
                  const SizedBox(width: 5),
                  titleText,
                ],
              ),
              trailingButton,
            ],
          ),
          description != null ?
            DescriptionText(description: description ?? '')
          :
            const SizedBox(height: 0)
        ],
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {
  final String description;
  const DescriptionText({required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  description,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
                      ),
                ),
              ),
    );
  }
}