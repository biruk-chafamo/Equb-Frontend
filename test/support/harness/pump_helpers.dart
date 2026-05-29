import 'package:flutter_test/flutter_test.dart';

/// Never use `pumpAndSettle` in this suite. Shimmer placeholders animate
/// forever, `SlideCountdownSeparated` ticks every second, and the round
/// countdown schedules a 5s `Future.delayed` on completion — so `pumpAndSettle`
/// waits for a frame queue that never drains and hangs until the CI timeout
/// instead of failing. Use these instead.
Future<void> pumpFrames(
  WidgetTester tester,
  int count, [
  Duration step = const Duration(milliseconds: 16),
]) async {
  for (var i = 0; i < count; i++) {
    await tester.pump(step);
  }
}

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 2),
  Duration step = const Duration(milliseconds: 50),
}) async {
  var elapsed = Duration.zero;
  while (elapsed < timeout) {
    await tester.pump(step);
    elapsed += step;
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Timed out after $timeout waiting for $finder');
}
