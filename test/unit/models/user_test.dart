import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders/user_builder.dart';

void main() {
  group('fromJson', () {
    test('parses the shape the backend actually sends', () {
      final user = User.fromJson(_payload());

      expect(user.id, 12);
      expect(user.username, 'alice');
      expect(user.firstName, 'Alice');
      expect(user.lastName, 'Bekele');
      expect(user.score, 4.5);
      expect(user.friends, [3, 4]);
      expect(user.joinedEqubIds, [7]);
      expect(user.profilePictureUrl, isNull);
    });

    test('score must arrive as a string', () {
      expect(
        () => User.fromJson(_payload(score: 4.5)),
        throwsA(isA<TypeError>()),
      );
    });

    test('a null score is a hard failure rather than a default', () {
      expect(
        () => User.fromJson(_payload(score: null)),
        throwsA(isA<TypeError>()),
      );
    });

    test('parses nested payment methods', () {
      final user = User.fromJson(_payload(paymentMethods: [
        {'id': 1, 'service': 'Venmo', 'detail': '@alice'},
      ]));

      expect(user.paymentMethods.single.service, 'Venmo');
      expect(user.paymentMethods.single.detail, '@alice');
    });

    test('keeps a profile picture url when one is present', () {
      final user =
          User.fromJson(_payload(profilePicture: 'https://cdn/pic.jpg'));

      expect(user.profilePictureUrl, 'https://cdn/pic.jpg');
    });
  });

  group('toJson', () {
    test('does not round-trip back through fromJson', () {
      final user = buildUser(score: 4.5);

      expect(
        () => User.fromJson(user.toJson()),
        throwsA(isA<TypeError>()),
        reason: 'toJson writes score as a double; fromJson demands a string',
      );
    });

    test('emits the snake_case keys the backend expects', () {
      final json = buildUser().toJson();

      expect(json.keys, containsAll(<String>['first_name', 'last_name']));
      expect(json.keys, containsAll(<String>['joined_equbs', 'profile_picture']));
      expect(json.keys, contains('selected_payment_methods'));
    });
  });
}

Map<String, dynamic> _payload({
  Object? score = '4.50',
  List<Map<String, dynamic>>? paymentMethods,
  String? profilePicture,
}) {
  return {
    'id': 12,
    'username': 'alice',
    'first_name': 'Alice',
    'last_name': 'Bekele',
    'score': score,
    'selected_payment_methods': paymentMethods ?? <Map<String, dynamic>>[],
    'friends': [3, 4],
    'joined_equbs': [7],
    'profile_picture': profilePicture,
  };
}
