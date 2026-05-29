import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('equbAmountNumberFormat', () {
    test('renders whole dollars to a single decimal place', () {
      expect(equbAmountNumberFormat.format(1234.56), r'$1,234.6');
      expect(equbAmountNumberFormat.format(200), r'$200.0');
      expect(equbAmountNumberFormat.format(0), r'$0.0');
    });

    test('groups thousands', () {
      expect(equbAmountNumberFormat.format(1000000), r'$1,000,000.0');
    });

    test('renders negatives with a leading minus', () {
      expect(equbAmountNumberFormat.format(-42.5), r'-$42.5');
    });
  });

  group('creationDateFormat', () {
    test('renders day-first with zero padding', () {
      expect(creationDateFormat.format(DateTime(2026, 5, 7)), '07/05/2026');
      expect(creationDateFormat.format(DateTime(2026, 12, 25)), '25/12/2026');
    });
  });
}
