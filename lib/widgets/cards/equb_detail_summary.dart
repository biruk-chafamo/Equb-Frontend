import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class EqubDetailSummary extends StatelessWidget {
  final String title;
  final Widget value;
  final Widget topRightVisual; // meant to be an icon or a discreptive visual
  final String additionalContentTitle;
  final String additionalContentValue;
  // final IconData detailIcon;

  const EqubDetailSummary({
    required this.title,
    required this.value,
    required this.topRightVisual,
    required this.additionalContentTitle,
    required this.additionalContentValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: AppPadding.globalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                ),
          ),
          const SizedBox(height: 10),
          value,
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    additionalContentTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    additionalContentValue,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              topRightVisual
            ],
          ),
        ],
      ),
    );
  }
}
