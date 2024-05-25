import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_circle_button.dart';
import 'package:flutter/material.dart';

class NotificationDetail extends StatelessWidget {
  final String notificationText;
  final String notificationSubText;
  final Widget? additionalContent;

  const NotificationDetail(
    this.notificationText,
    this.notificationSubText, {
    this.additionalContent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: AppMargin.globalMargin,
          padding: AppPadding.globalPadding,
          decoration: SecondaryBoxDecor(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    notificationText,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    notificationSubText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  if (additionalContent != null)
                    additionalContent!
                  else
                    Text("")
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          right: 0,
          child: CustomCircleButton(
            child: Icon(Icons.notification_important_rounded),
            showBorder: false,
            showBackground: false,
          ),
        ),
      ],
    );
  }
}
