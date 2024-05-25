import 'package:equb_v3_frontend/models/authentication/user.dart';
import 'package:equb_v3_frontend/repositories/example_data.dart';
import 'package:equb_v3_frontend/services/authentication_service.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/utils/themes.dart';
import 'package:equb_v3_frontend/widgets/buttons/bidding_input.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_circle_button.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/buttons/navigation_text_button.dart';
import 'package:equb_v3_frontend/widgets/buttons/user_avatar_button.dart';
import 'package:equb_v3_frontend/widgets/cards/equb_detail.dart';
import 'package:equb_v3_frontend/widgets/cards/notification_detail.dart';
import 'package:equb_v3_frontend/widgets/cards/user_detail.dart';
import 'package:equb_v3_frontend/widgets/sections/interest_rate_chart.dart';
import 'package:equb_v3_frontend/widgets/sections/pending_reciepts.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:equb_v3_frontend/widgets/tiles/boardered_tile.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthenticationService(baseUrl: "http://0.0.0.0:8000");
    final Future<User> currentUser = authService.login("sosi", "XY8g,C11");

    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  children: [
                    const CustomElevatedButton(child: Text('Button 1')),
                    const CustomCircleButton(child: Icon(Icons.add)),
                    const CustomCircleButton(
                      showBorder: true,
                      showBackground: true,
                      child: Icon(Icons.add),
                    ),
                    const NavigationTextButton(data: 'See All'),
                    UserAvatarButton(thisUser),
                    FutureBuilder(
                      future: currentUser,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return UserDetail(snapshot.data!);
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          return Text('nothing');
                        }
                      },
                    ),
                    UserDetail(thisUser),
                  ],
                ),
                const SectionTitleTile(
                  "Interest Rate",
                  Icons.trending_up_outlined,
                  NavigationTextButton(data: 'See All'),
                ),
                BoarderedTile(
                  UserDetail(thisUser),
                  const NavigationTextButton(data: 'See All'),
                ),
                const SectionTitleTile(
                  "Summary",
                  Icons.payments_outlined,
                  Text(" "),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EqubDetail(
                        title: "Amount",
                        detailIcon: Icons.monetization_on_outlined,
                        value: "998",
                        topRightVisual: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                size: 10,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                              ),
                              Text(
                                "2%",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSecondaryContainer,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        additionalContentTitle: "Base",
                        additionalContentValue: "1000",
                      ),
                      EqubDetail(
                        title: "Round",
                        detailIcon: Icons.timer_outlined,
                        value: "12/18",
                        topRightVisual: Transform.scale(
                          scale: 0.5,
                          child: const CircularProgressIndicator(
                            value: 12 / 18,
                            backgroundColor: AppColors.secondaryContainer,
                            strokeWidth: 10,
                            color: AppColors.onSecondaryContainer,
                          ),
                        ),
                        additionalContentTitle: "Cycle",
                        additionalContentValue: "30 days",
                      ),
                      const EqubDetail(
                        title: "Status",
                        detailIcon: Icons.offline_bolt_outlined,
                        value: "Active",
                        // green circle
                        topRightVisual: Icon(
                          Icons.circle,
                          color: AppColors.onSecondaryContainer,
                          size: 30,
                        ),
                        additionalContentTitle: "",
                        additionalContentValue: "",
                      ),
                    ],
                  ),
                ),
                const SectionTitleTile(
                  "Bidding",
                  Icons.payments_outlined,
                  NavigationTextButton(data: "Expand"),
                ),
                BoarderedTile(
                  NumericStepButton(
                    minValue: 0,
                    maxValue: 30,
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                  const CustomElevatedButton(
                    child: Text("Placed Bid"),
                  ),
                ),
                InterestRateChart(),
                const SectionTitleTile("Equb Winner", Icons.group, Text(" ")),
                const NotificationDetail(
                  "You have won round 3!",
                  "3/12 have payed you.",
                  additionalContent: CustomElevatedButton(
                    child: Text("confirm"),
                  ),
                ),
                const SectionTitleTile(
                  "Payment Confirmations",
                  Icons.payments_outlined,
                  NavigationTextButton(data: "See All"),
                ),
                PendingReciepts(
                  examplePaymentStatus.confirmationRequestedMembers,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
