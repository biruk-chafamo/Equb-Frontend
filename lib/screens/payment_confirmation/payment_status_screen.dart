import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_state.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/models/payment_confirmation_request/payment_confirmation_request.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/sections/list_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PaymentStatusScreen extends StatelessWidget {
  const PaymentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Column(
            children: [
              Text(
                "Payment Status",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              )
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: SizedBox(
                  width: 80,
                  child: Center(
                    child: Text('Pending'),
                  ),
                ),
              ),
              Tab(
                child: SizedBox(
                  width: 80,
                  child: Center(
                    child: Text('Paid'),
                  ),
                ),
              ),
              Tab(
                child: SizedBox(
                  width: 80,
                  child: Center(
                    child: Text('Unpaid'),
                  ),
                ),
              )
            ],
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: smallScreenSize),
            child: const SafeArea(
              child: TabBarView(
                children: [
                  PaymentStatusTab(
                    type: "unconfirmed",
                    emptyMessage:
                        "There are no new payment confirmation requests.",
                    description: "These payments have not been confirmed yet",
                  ),
                  PaymentStatusTab(
                    type: "confirmed",
                    emptyMessage:
                        "No equb member has made a confirmed payment to this round's winner.",
                    description:
                        "Payments from these members have been confirmed by this round's winner.",
                  ),
                  PaymentStatusTab(
                    type: "unpaid",
                    emptyMessage:
                        "This round's winner has recieved payment confirmation requests from all members.",
                    description:
                        "These members have not sent payment requests to this round's winner.",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentStatusTab extends StatelessWidget {
  final String type;
  final String emptyMessage;
  final String description;
  final Widget? emptyButton;

  const PaymentStatusTab({
    required this.type,
    required this.emptyMessage,
    required this.description,
    this.emptyButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EqubBloc, EqubDetailState>(
        builder: (context, equbState) {
      return BlocBuilder<PaymentConfirmationRequestBloc,
          PaymentConfirmationRequestState>(
        builder: (context, state) {
          if (state.status != PaymentConfirmationRequestStatus.success ||
              equbState.status != EqubDetailStatus.success) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final Widget usersList;
            final List<PaymentConfirmationRequest> requests;
            final List<User> unpaidUsers;
            if (type == "unconfirmed") {
              requests = state.paymentConfirmationRequests
                  .where((e) => e.isAccepted == false)
                  .toList();
              usersList = ListUnconfirmedPayers(requests, requests.length);
              unpaidUsers = [];
            } else if (type == "confirmed") {
              requests = state.paymentConfirmationRequests
                  .where((e) => e.isAccepted)
                  .toList();
              usersList = ListConfirmedPayers(requests, requests.length);
              unpaidUsers = [];
            } else {
              requests = [];
              unpaidUsers = equbState.equbDetail!.unpaidMembers;
              usersList = ListUnpaidPayers(unpaidUsers, unpaidUsers.length);
            }

            return (requests.isEmpty && type != "unpaid") ||
                    (unpaidUsers.isEmpty && type == "unpaid")
                ? Padding(
                    padding: AppPadding.globalPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          emptyMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        emptyButton ?? const SizedBox()
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: AppPadding.globalPadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                description,
                              ),
                            ],
                          ),
                        ),
                        usersList
                      ],
                    ),
                  );
          }
        },
      );
    });
  }
}
