import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/cards/equb_overview.dart';
import 'package:equb_v3_frontend/widgets/sections/upcoming_round_calander.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders/equb_builder.dart';

void main() {
  group('getEqubType', () {
    test('a completed equb is past regardless of its active flag', () {
      expect(
        getEqubType(buildEqubDetail(isCompleted: true, isActive: true)),
        EqubType.past,
      );
      expect(
        getEqubType(buildEqubDetail(isCompleted: true, isActive: false)),
        EqubType.past,
      );
    });

    test('an active, incomplete equb is active', () {
      expect(
        getEqubType(buildEqubDetail(isCompleted: false, isActive: true)),
        EqubType.active,
      );
    });

    test('an inactive, incomplete equb is pending', () {
      expect(
        getEqubType(buildEqubDetail(isCompleted: false, isActive: false)),
        EqubType.pending,
      );
    });
  });

  group('getPaymentStageColor', () {
    test('completion outranks every other stage', () {
      final color = getPaymentStageColor(buildEqubDetail(
        isCompleted: true,
        isActive: true,
        isInPaymentStage: true,
      ));

      expect(color, AppColors.onPrimary.withValues(alpha: 0.3));
    });

    test('a pending equb is amber', () {
      final color = getPaymentStageColor(
          buildEqubDetail(isCompleted: false, isActive: false));

      expect(color, const Color.fromARGB(255, 236, 200, 21));
    });

    test('an equb collecting payments is red', () {
      final color = getPaymentStageColor(buildEqubDetail(
        isCompleted: false,
        isActive: true,
        isInPaymentStage: true,
      ));

      expect(color, const Color.fromARGB(255, 197, 21, 18));
    });

    test('a running equb between rounds is green', () {
      final color = getPaymentStageColor(buildEqubDetail(
        isCompleted: false,
        isActive: true,
        isInPaymentStage: false,
      ));

      expect(color, Colors.green.shade400);
    });
  });

  group('getHashCode', () {
    test('ignores the time of day', () {
      expect(
        getHashCode(DateTime(2026, 8, 12, 9, 30)),
        getHashCode(DateTime(2026, 8, 12, 23, 59)),
      );
    });

    test('separates adjacent days, months and years', () {
      final day = getHashCode(DateTime(2026, 8, 12));

      expect(day, isNot(getHashCode(DateTime(2026, 8, 13))));
      expect(day, isNot(getHashCode(DateTime(2026, 9, 12))));
      expect(day, isNot(getHashCode(DateTime(2027, 8, 12))));
    });

    test('does not collide across a realistic calendar window', () {
      final start = DateTime(2024, 1, 1);
      final codes = <int>{};
      for (var i = 0; i < 365 * 6; i++) {
        codes.add(getHashCode(start.add(Duration(days: i))));
      }

      expect(codes.length, 365 * 6);
    });
  });
}
