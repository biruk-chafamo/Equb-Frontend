import 'package:cached_network_image/cached_network_image.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/widgets/buttons/user_avatar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/user_builder.dart';
import '../support/fakes/fake_user_repository.dart';

void main() {
  late UserBloc userBloc;

  setUp(() => userBloc = UserBloc(userRepository: FakeUserRepository()));
  tearDown(() async => userBloc.close());

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(value: userBloc, child: Scaffold(body: child)),
        ),
      );

  testWidgets('a user with no picture shows their initials', (tester) async {
    await pump(
      tester,
      UserAvatarButton(buildUserSummary(firstName: 'Alice', lastName: 'Abebe')),
    );

    expect(find.text('AA'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);
  });

  testWidgets('a user with a picture loads it through the cache', (tester) async {
    await pump(
      tester,
      UserAvatarButton(buildUserSummary(
        firstName: 'Alice',
        lastName: 'Abebe',
        profilePictureUrl: 'https://cdn.example/media/profile_pictures/a.jpg',
      )),
    );

    // the URL goes to the caching widget rather than being fetched by hand
    final image = tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    expect(image.imageUrl, 'https://cdn.example/media/profile_pictures/a.jpg');
  });

  testWidgets('initials stand in while the picture is loading', (tester) async {
    await pump(
      tester,
      UserAvatarButton(buildUserSummary(
        firstName: 'Biruk',
        lastName: 'Chafamo',
        profilePictureUrl: 'https://cdn.example/media/profile_pictures/b.jpg',
      )),
    );
    await tester.pump();

    // no blank circle and no spinner: the placeholder is the initials avatar
    expect(find.text('BC'), findsOneWidget);
  });

  testWidgets('no fetch is dispatched when the avatar is built', (tester) async {
    final repository = FakeUserRepository();
    userBloc = UserBloc(userRepository: repository);

    await pump(tester, UserAvatarButton(buildUserSummary()));

    // the widget used to fire one event per instance, so the same user was
    // downloaded once per row on screen
    expect(repository.calls, isEmpty);
  });
}
