import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/widgets/cards/equb_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/equb_builder.dart';
import '../support/builders/user_builder.dart';
import '../support/fakes/fake_equb_repository.dart';
import '../support/fakes/fake_payment_confirmation_request_repository.dart';
import '../support/harness/pump_helpers.dart';

void main() {
  late EqubBloc equbBloc;
  late PaymentConfirmationRequestBloc paymentBloc;

  setUp(() {
    paymentBloc = PaymentConfirmationRequestBloc(
      paymentConfirmationRequestRepository:
          FakePaymentConfirmationRequestRepository(),
    );
    equbBloc = EqubBloc(
      equbRepository: FakeEqubRepository(),
      paymentBloc: paymentBloc,
    );
  });

  tearDown(() async {
    await equbBloc.close();
    await paymentBloc.close();
  });

  Future<void> pumpFor(WidgetTester tester, EqubDetail equbDetail) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<EqubBloc>.value(
          value: equbBloc,
          child: Scaffold(
            body: TimeLeftUntilCollection(equbDetail: equbDetail),
          ),
        ),
      ),
    );
    await pumpFrames(tester, 2);
  }

  testWidgets('a running round counts down to the payment stage',
      (tester) async {
    await pumpFor(tester, buildEqubDetail(isInPaymentStage: false));

    expect(find.textContaining('payment starts in', findRichText: true),
        findsOneWidget);
  });

  testWidgets('the payment stage without a winner says one is being selected',
      (tester) async {
    await pumpFor(
        tester, buildEqubDetail(isInPaymentStage: true, latestWinner: null));

    expect(find.textContaining('winner is being selected', findRichText: true),
        findsOneWidget);
  });

  testWidgets('the payment stage with a winner says payments are running',
      (tester) async {
    await pumpFor(
      tester,
      buildEqubDetail(isInPaymentStage: true, latestWinner: buildUser()),
    );

    expect(
        find.textContaining('payments are in progress...', findRichText: true),
        findsOneWidget);
  });

  testWidgets('an overdue round says a winner is being selected',
      (tester) async {
    await pumpFor(
      tester,
      buildEqubDetail(
        isInPaymentStage: false,
        timeLeftTillNextRound: const {
          'days': -1,
          'hours': 0,
          'minutes': 0,
          'seconds': 0,
        },
      ),
    );

    expect(find.textContaining('winner is being selected', findRichText: true),
        findsOneWidget);
  });

  testWidgets('the status follows a new equb pushed into the same widget',
      (tester) async {
    await pumpFor(tester, buildEqubDetail(isInPaymentStage: false));
    expect(find.textContaining('payment starts in', findRichText: true),
        findsOneWidget);

    await pumpFor(
      tester,
      buildEqubDetail(isInPaymentStage: true, latestWinner: buildUser()),
    );

    expect(
        find.textContaining('payments are in progress...', findRichText: true),
        findsOneWidget);
    expect(find.textContaining('payment starts in', findRichText: true),
        findsNothing);
  });
}
