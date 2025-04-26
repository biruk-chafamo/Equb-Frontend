import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_event.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/screens/equb/equb_detail_screen.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/cards/equb_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PaymentStatusManagement extends StatelessWidget {
  const PaymentStatusManagement(
      {super.key, required this.equbDetail, required this.currentUser});

  final EqubDetail equbDetail;
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    final Widget button;
    final Color paymentStatusTextColor;

    if (equbDetail.userPaymentStatus == PaymentStatus.winner) {
      button = CustomOutlinedButton(
        onPressed: () {
          context.read<PaymentConfirmationRequestBloc>().add(
                FetchPaymentConfirmationRequests(
                    equbDetail.id, equbDetail.currentRound),
              );
          context.pushNamed('confirmations');
        },
        showBackground: true,
        child: "Verify Payment Reciepts",
      );
    } else if (equbDetail.userPaymentStatus == PaymentStatus.confirmed ||
        equbDetail.userPaymentStatus == PaymentStatus.unconfirmed) {
      button = const SizedBox(
        height: 0,
      );
    } else {
      button = CustomOutlinedButton(
        onPressed: () {
          context.pushNamed('payment_notice');
        },
        showBackground: true,
        child: "Send Payment Notice",
      );
    }

    if (equbDetail.userPaymentStatus == PaymentStatus.winner) {
      paymentStatusTextColor = Colors.green.shade400;
    } else if (equbDetail.userPaymentStatus == PaymentStatus.confirmed) {
      paymentStatusTextColor = Colors.green.shade400;
    } else if (equbDetail.userPaymentStatus == PaymentStatus.unconfirmed) {
      paymentStatusTextColor = Theme.of(context).colorScheme.onTertiary;
    } else {
      paymentStatusTextColor = Colors.red.shade400;
    }

    final latestWinner = equbDetail.latestWinner;
    final Widget paymentStatusManagementBox =
        equbDetail.isInPaymentStage && latestWinner != null
            ? PaymentStatusManagementBox(
                equbDetail: equbDetail,
                paymentStatusTextColor: paymentStatusTextColor,
                button: button,
                latestWinner: latestWinner,
              )
            : const SizedBox(height: 0);
    return Column(
      children: [
        TimeLeftUntilCollection(equbDetail: equbDetail),
        paymentStatusManagementBox
      ],
    );
  }
}

class PaymentStatusManagementBox extends StatelessWidget {
  const PaymentStatusManagementBox({
    super.key,
    required this.equbDetail,
    required this.paymentStatusTextColor,
    required this.button,
    required this.latestWinner,
  });

  final EqubDetail equbDetail;
  final Color paymentStatusTextColor;
  final Widget button;
  final User latestWinner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: PrimaryBoxDecor(),
          padding: AppPadding.globalPadding,
          margin: AppMargin.globalMargin,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            latestWinner.username,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            "won round ${equbDetail.currentRound}",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          context.read<PaymentConfirmationRequestBloc>().add(
                                FetchPaymentConfirmationRequests(
                                    equbDetail.id, equbDetail.currentRound),
                              );
                          context.pushNamed('confirmations');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Your Payment Status",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                      ),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: smallIconSize,
                                ),
                              ],
                            ),
                            Text(
                              equbDetail.userPaymentStatus.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: paymentStatusTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: button,
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "${(equbDetail.maxMembers - 1) - (equbDetail.unpaidMembers.length)} ",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextSpan(
                          text:
                              "/ ${equbDetail.maxMembers - 1} members have paid",
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  LinearProgressIndicator(
                    value: ((equbDetail.maxMembers - 1) -
                            (equbDetail.unpaidMembers.length)) /
                        (equbDetail.maxMembers - 1),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.7)),
                  ),
                ]
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: e,
                      ),
                    )
                    .toList()),
          ),
        ),
      ],
    );
  }
}
