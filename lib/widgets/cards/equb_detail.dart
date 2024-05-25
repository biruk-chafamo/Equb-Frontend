import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_circle_button.dart';
import 'package:flutter/material.dart';

class EqubDetail extends StatelessWidget {
  final String title;
  final String value;
  final Widget topRightVisual; // meant to be an icon or a discreptive visual
  final String? additionalContentTitle;
  final String? additionalContentValue;
  final IconData detailIcon;

  const EqubDetail({
    required this.title,
    required this.value,
    required this.topRightVisual,
    required this.detailIcon,
    this.additionalContentTitle,
    this.additionalContentValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double iconRadius = 25;
    return Stack(
      children: [
        Container(
          margin: AppMargin.globalMargin,
          padding: const EdgeInsets.symmetric(
            horizontal: iconRadius / 4,
            vertical: iconRadius / 4,
          ),
          child: SizedBox(
            height: 130 + iconRadius,
            child: AspectRatio(
              aspectRatio: 0.95,
              child: Container(
                padding: AppPadding.globalPadding,
                decoration: PrimaryBoxDecor(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(detailIcon, size: 20, color: AppColors.onTertiary),
                        const SizedBox(width: 10),
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(0.5),
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          additionalContentTitle!,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    fontWeight: FontWeight.w100,
                                  ),
                        ),
                        Text(
                          additionalContentValue!,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: iconRadius / 4,
          bottom: iconRadius,
          child: CustomCircleButton(
            radius: iconRadius,
            child: topRightVisual,
          ),
        ),
      ],
    );
  }
}
