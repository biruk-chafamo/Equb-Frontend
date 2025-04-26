import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_event.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_state.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/models/payment_method/payment_method.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/cards/user_detail.dart';
import 'package:equb_v3_frontend/widgets/sections/list_users.dart';
import 'package:equb_v3_frontend/widgets/tiles/boardered_tile.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:choice/choice.dart';

class PaymentNoticeScreen extends StatefulWidget {
  const PaymentNoticeScreen({super.key});

  @override
  PaymentNoticeScreenState createState() => PaymentNoticeScreenState();
}

class PaymentNoticeScreenState extends State<PaymentNoticeScreen> {
  final TextEditingController _messageController = TextEditingController();
  int? _selectedServiceId;
  String? _selectedServiceWinnerDetail;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedServiceId when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      final equbDetailState = context.read<EqubBloc>().state;
      if (authState is AuthAuthenticated) {
        final currentUserPaymentMethods = authState.user.paymentMethods;

        final equbDetail = equbDetailState.equbDetail;
        final latestWinner = equbDetail?.latestWinner;
        final List<PaymentMethod> sharedPaymentMethods;
        if (equbDetail != null && latestWinner != null) {
          final winnerPaymentMethods = latestWinner.paymentMethods;
          sharedPaymentMethods = winnerPaymentMethods
              .where((winnerMethod) => currentUserPaymentMethods
                  .any((method) => method.service == winnerMethod.service))
              .toList();
        } else {
          sharedPaymentMethods = [];
        }

        if (sharedPaymentMethods.isNotEmpty) {
          setState(() {
            _selectedServiceId = sharedPaymentMethods.first.id;
            _selectedServiceWinnerDetail = sharedPaymentMethods.first.detail;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _messageController
        .dispose(); // Dispose of the controller when the screen is closed
    super.dispose();
  }

  void _onSelectedServiceChanged(PaymentMethod paymentMethod) {
    setState(() {
      _selectedServiceId = paymentMethod.id;
      _selectedServiceWinnerDetail = paymentMethod.detail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final equbBloc = context.read<EqubBloc>();
    final paymentConfirmationRequestBloc =
        context.read<PaymentConfirmationRequestBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "Payment Notice",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            )
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: smallScreenSize),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, authState) {
                              if (authState is AuthAuthenticated) {
                                return BlocBuilder<EqubBloc, EqubDetailState>(
                                  builder: (context, state) {
                                    if (state.status ==
                                        EqubDetailStatus.success) {
                                      final currentUserPaymentMethods =
                                          authState.user.paymentMethods;
                                      final equbDetail = state.equbDetail;
                                      final latestWinner =
                                          equbDetail?.latestWinner;
                                      if (equbDetail == null ||
                                          latestWinner == null) {
                                        return const Center(
                                            child: Text("No winner found"));
                                      }
                                      final winnerPaymentMethods =
                                          latestWinner.paymentMethods;
                                      final sharedPaymentMethods =
                                          winnerPaymentMethods
                                              .where((winnerMethod) =>
                                                  currentUserPaymentMethods.any(
                                                      (method) =>
                                                          method.service ==
                                                          winnerMethod.service))
                                              .toList();
                                      return Container(
                                        margin: AppMargin.globalMargin,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: AppPadding.globalPadding,
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'Confirm payment to ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSecondaryContainer),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5, top: 5),
                                              child: BoarderedTile(
                                                UserDetail(latestWinner),
                                                const Text(''),
                                                onTap: () {
                                                  context.read<UserBloc>().add(
                                                      FetchUserById(
                                                          latestWinner.id));
                                                  GoRouter.of(context)
                                                      .pushNamed(
                                                          'user_profile');
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding: AppPadding.globalPadding,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    equbAmountNumberFormat
                                                        .format(equbDetail
                                                                .currentAward /
                                                            (equbDetail
                                                                .maxMembers)),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 50,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .onSecondaryContainer
                                                              .withOpacity(0.8),
                                                        ),
                                                  ),
                                                  Text(
                                                    " round ${equbDetail.currentRound} ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onTertiary
                                                                    .withOpacity(
                                                                        0.05),
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onTertiary),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const SectionTitleTile(
                                                'Shared Payment Methods',
                                                Icons.payment,
                                                Text('')),
                                            Padding(
                                              padding: AppPadding.globalPadding,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Wrap(
                                                    spacing: 10.0,
                                                    runSpacing: 10.0,
                                                    children:
                                                        List<Widget>.generate(
                                                            sharedPaymentMethods
                                                                .length, (i) {
                                                      final method =
                                                          sharedPaymentMethods[
                                                              i];
                                                      return ChoiceChip(
                                                        selected:
                                                            _selectedServiceId ==
                                                                method.id,
                                                        showCheckmark: false,
                                                        onSelected: (selected) {
                                                          if (selected) {
                                                            _onSelectedServiceChanged(
                                                                method);
                                                          }
                                                        },
                                                        label: Text(
                                                            method.service),
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            _selectedServiceWinnerDetail == ''
                                                ? Container()
                                                : Padding(
                                                    padding: AppPadding
                                                        .globalPadding,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          " $_selectedServiceWinnerDetail",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleLarge
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  backgroundColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onTertiary
                                                                      .withOpacity(
                                                                          0.05),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onTertiary),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                          Container(
                            margin: AppMargin.globalMargin,
                            padding: AppPadding.globalPadding,
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                focusedBorder: const UnderlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer
                                        .withOpacity(0.8)),
                                hintText: 'Message to recipient (optional)',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer
                                          .withOpacity(0.5),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                BlocConsumer<PaymentConfirmationRequestBloc,
                        PaymentConfirmationRequestState>(
                    listener: (context, requestState) {
                  final equbId = requestState.equbId;
                  if (requestState.status ==
                          PaymentConfirmationRequestStatus.success &&
                      equbId != null) {
                    equbBloc.add(FetchEqubDetail(equbId));
                    GoRouter.of(context).pop();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        requestState.status ==
                                PaymentConfirmationRequestStatus.loading
                            ? 'Processing payment confirmation ...'
                            : requestState.status ==
                                    PaymentConfirmationRequestStatus.success
                                ? 'Payment confirmations updated successfully'
                                : 'Failed updating payment confirmations',
                      ),
                    ),
                  );
                }, builder: (context, requestState) {
                  return BlocBuilder<EqubBloc, EqubDetailState>(
                    builder: (context, state) {
                      if (state.status == EqubDetailStatus.success) {
                        final equbDetail = state.equbDetail;
                        if (equbDetail == null) {
                          return Center(
                            child: CustomOutlinedButton(
                              onPressed: () {
                                GoRouter.of(context).goNamed('equbs_overview');
                              },
                              child: 'Refresh',
                            ),
                          );
                        }
                        return Padding(
                          padding: AppPadding.globalPadding,
                          child: CustomOutlinedButton(
                            onPressed: () {
                              final message = _messageController.text.trim();
                              paymentConfirmationRequestBloc
                                  .add(CreatePaymentConfirmationRequest(
                                equbDetail.id,
                                equbDetail.currentRound,
                                _selectedServiceId!,
                                message,
                              ));
                            },
                            child: 'Send',
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
