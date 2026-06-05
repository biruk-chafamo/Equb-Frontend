import 'package:equb_v3_frontend/utils/cycle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('presets', () {
    test('map to whole-day Django timedeltas', () {
      expect(buildCycleString(preset: 'Weekly'), '7 00:00:00');
      expect(buildCycleString(preset: 'Monthly'), '30 00:00:00');
      expect(buildCycleString(preset: 'Yearly'), '365 00:00:00');
    });

    test('ignore custom fields', () {
      expect(
        buildCycleString(preset: 'Weekly', days: '3', hours: '9'),
        '7 00:00:00',
      );
    });

    test('an unrecognised or absent preset falls back to one day', () {
      expect(buildCycleString(preset: ''), defaultCycle);
      expect(buildCycleString(preset: null), defaultCycle);
      expect(buildCycleString(preset: 'Fortnightly'), defaultCycle);
    });
  });

  group('custom', () {
    test('days only still carries a full time component', () {
      expect(buildCycleString(preset: 'Custom', days: '5'), '5 00:00:00');
    });

    test('minutes only zero-pads to a full clock', () {
      expect(buildCycleString(preset: 'Custom', minutes: '30'), '00:30:00');
    });

    test('hours only zero-pads to a full clock', () {
      expect(buildCycleString(preset: 'Custom', hours: '2'), '02:00:00');
    });

    test('combines days, hours and minutes', () {
      expect(
        buildCycleString(
            preset: 'Custom', days: '5', hours: '2', minutes: '30'),
        '5 02:30:00',
      );
    });

    test('does not pad a multi-digit day count', () {
      expect(buildCycleString(preset: 'Custom', days: '120'), '120 00:00:00');
    });

    test('tolerates whitespace and non-numeric input', () {
      expect(buildCycleString(preset: 'Custom', days: ' 3 '), '3 00:00:00');
      expect(buildCycleString(preset: 'Custom', hours: 'abc'), defaultCycle);
    });

    test('an entirely empty custom cycle falls back to one day', () {
      expect(buildCycleString(preset: 'Custom'), defaultCycle);
      expect(
        buildCycleString(preset: 'Custom', days: '0', hours: '0', minutes: '0'),
        defaultCycle,
      );
    });
  });
}
