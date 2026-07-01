import 'package:equb_v3_frontend/models/equb/equb.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equb.fromJson', () {
    test('parses the shape the backend actually sends', () {
      final equb = Equb.fromJson(_payload());

      expect(equb.id, 7);
      expect(equb.name, 'Sunrise');
      expect(equb.amount, 1200.0);
      expect(equb.maxMembers, 6);
      expect(equb.cycle, '7 00:00:00');
      expect(equb.currentRound, 2);
      expect(equb.members, isEmpty);
    });

    test('amount must arrive as a string', () {
      expect(
        () => Equb.fromJson(_payload(amount: 1200.0)),
        throwsA(isA<TypeError>()),
      );
    });

    test('creationDate stays an unparsed string', () {
      final equb = Equb.fromJson(_payload());

      expect(equb.creationDate, '2026-01-15T10:00:00Z');
      expect(equb.creationDate, isA<String>());
    });

    test('parses nested members', () {
      final equb = Equb.fromJson(_payload(members: [
        {
          'id': 12,
          'username': 'alice',
          'first_name': 'Alice',
          'last_name': 'Bekele',
          'score': '4.50',
          'selected_payment_methods': <Map<String, dynamic>>[],
          'friends': <int>[],
          'joined_equbs': <int>[],
          'profile_picture': null,
        },
      ]));

      expect(equb.members.single.firstName, 'Alice');
    });
  });

  group('EqubCreationDTO', () {
    test('serializes to the snake_case keys the backend expects', () {
      final json = EqubCreationDTO(
        name: 'Sunrise',
        amount: 1200,
        maxMembers: 6,
        cycle: '7 00:00:00',
        isPrivate: true,
      ).toJson();

      expect(json, {
        'name': 'Sunrise',
        'amount': 1200.0,
        'max_members': 6,
        'cycle': '7 00:00:00',
        'is_private': true,
      });
    });

    test('sends amount as a number even though Equb parses it from a string',
        () {
      final json = EqubCreationDTO(
        name: 'Sunrise',
        amount: 1200,
        maxMembers: 6,
        cycle: '7 00:00:00',
        isPrivate: false,
      ).toJson();

      expect(json['amount'], isA<double>());
    });
  });
}

Map<String, dynamic> _payload({
  Object amount = '1200.00',
  List<Map<String, dynamic>>? members,
}) {
  return {
    'id': 7,
    'name': 'Sunrise',
    'amount': amount,
    'max_members': 6,
    'cycle': '7 00:00:00',
    'current_round': 2,
    'creation_date': '2026-01-15T10:00:00Z',
    'is_private': false,
    'is_active': true,
    'is_completed': false,
    'is_in_payment_stage': false,
    'members': members ?? <Map<String, dynamic>>[],
  };
}
