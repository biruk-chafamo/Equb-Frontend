import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/widgets/buttons/bidding_input.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes/fake_equb_repository.dart';
import '../support/fakes/fake_payment_confirmation_request_repository.dart';
import '../support/harness/pump_helpers.dart';

void main() {
  late FakeEqubRepository equbRepository;
  late PaymentConfirmationRequestBloc paymentBloc;
  late EqubBloc equbBloc;

  setUp(() {
    equbRepository = FakeEqubRepository();
    paymentBloc = PaymentConfirmationRequestBloc(
      paymentConfirmationRequestRepository:
          FakePaymentConfirmationRequestRepository(),
    );
    equbBloc =
        EqubBloc(equbRepository: equbRepository, paymentBloc: paymentBloc);
  });

  tearDown(() async {
    await equbBloc.close();
    await paymentBloc.close();
  });

  Future<void> pumpBidding(
    WidgetTester tester, {
    double minValue = 0,
    double maxValue = 1,
    bool isWonByUser = false,
    bool isFinalRound = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<EqubBloc>.value(
          value: equbBloc,
          child: Scaffold(
            body: NumericStepButton(
              equbId: 7,
              minValue: minValue,
              maxValue: maxValue,
              isWonByUser: isWonByUser,
              isFinalRound: isFinalRound,
            ),
          ),
        ),
      ),
    );
    await pumpFrames(tester, 2);
  }

  double displayedPercent(WidgetTester tester) {
    final text = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data)
        .firstWhere((d) => d != null && d.endsWith('%'))!;
    return double.parse(text.replaceAll('%', ''));
  }

  Future<void> tapUp(WidgetTester tester, int times) async {
    for (var i = 0; i < times; i++) {
      await tester.tap(find.byIcon(Icons.keyboard_arrow_up_rounded));
      await tester.pump();
    }
  }

  testWidgets('starts at the current minimum bid', (tester) async {
    await pumpBidding(tester, minValue: 0.02);

    expect(displayedPercent(tester), closeTo(2.0, 0.001));
  });

  testWidgets('stepping up raises the bid by half a percent', (tester) async {
    await pumpBidding(tester, minValue: 0.02);

    await tapUp(tester, 2);

    expect(displayedPercent(tester), closeTo(3.0, 0.001));
  });

  testWidgets('stepping down will not go below the current minimum',
      (tester) async {
    await pumpBidding(tester, minValue: 0.02);

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
      await tester.pump();
    }

    expect(displayedPercent(tester), closeTo(2.0, 0.001));
  });

  testWidgets('the bid never exceeds the maximum', (tester) async {
    await pumpBidding(tester, minValue: 0, maxValue: 1);

    await tapUp(tester, 220);

    expect(displayedPercent(tester), lessThanOrEqualTo(100.0));
  });

  testWidgets('place bid is disabled until the bid is raised', (tester) async {
    await pumpBidding(tester, minValue: 0.02);

    final before = tester.widget<CustomOutlinedButton>(
        find.widgetWithText(CustomOutlinedButton, 'place bid'));
    expect(before.onPressed, isNull);

    await tapUp(tester, 1);

    final after = tester.widget<CustomOutlinedButton>(
        find.widgetWithText(CustomOutlinedButton, 'place bid'));
    expect(after.onPressed, isNotNull);
  });

  testWidgets('placing a bid dispatches the raised amount', (tester) async {
    await pumpBidding(tester, minValue: 0.02);

    await tapUp(tester, 1);
    await tester.tap(find.widgetWithText(CustomOutlinedButton, 'place bid'));
    await pumpFrames(tester, 3);

    expect(
      equbRepository.calls.where((c) => c.startsWith('placeBid(7,')),
      isNotEmpty,
    );
  });

  testWidgets('bidding is disabled in the final round', (tester) async {
    await pumpBidding(tester, minValue: 0.02, isFinalRound: true);

    await tapUp(tester, 3);

    expect(displayedPercent(tester), closeTo(2.0, 0.001));
    final button = tester.widget<CustomOutlinedButton>(
        find.widgetWithText(CustomOutlinedButton, 'place bid'));
    expect(button.onPressed, isNull);
  });

  testWidgets('bidding is disabled once the user has won', (tester) async {
    await pumpBidding(tester, minValue: 0.02, isWonByUser: true);

    await tapUp(tester, 3);

    expect(displayedPercent(tester), closeTo(2.0, 0.001));
  });
}
