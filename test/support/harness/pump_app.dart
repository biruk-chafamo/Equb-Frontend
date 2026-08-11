import 'package:equb_v3_frontend/main.dart';
import 'package:equb_v3_frontend/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/test_dependencies.dart';
import 'pump_helpers.dart';

const Size mobileSize = Size(600, 1200);
const Size splitScreenSize = Size(1400, 1000);

Future<void> pumpApp(
  WidgetTester tester,
  TestDependencies deps, {
  String at = '/',
  Size size = mobileSize,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(App(
    dependencies: deps.build(),
    router: createRouter(initialLocation: at),
  ));
  await pumpFrames(tester, 5);
}
