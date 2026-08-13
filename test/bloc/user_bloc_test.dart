import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/user_builder.dart';
import '../support/fakes/fake_user_repository.dart';

void main() {
  late FakeUserRepository userRepository;

  final alice = buildUser(id: 1, firstName: 'Alice');
  final bob = buildUser(id: 2, firstName: 'Bob');

  setUp(() {
    userRepository = FakeUserRepository();
  });

  UserBloc build() => UserBloc(userRepository: userRepository);

  group('fetch', () {
    blocTest<UserBloc, UserState>(
      'search results land in users',
      build: build,
      act: (bloc) {
        userRepository.searchResult = [alice, bob];
        bloc.add(const FetchUsersByName('a'));
      },
      expect: () => [
        isA<UserState>().having((s) => s.status, 'status', UserStatus.loading),
        isA<UserState>()
            .having((s) => s.status, 'status', UserStatus.success)
            .having((s) => s.users, 'users', [alice, bob]),
      ],
    );

    blocTest<UserBloc, UserState>(
      'a fetched user by id lands in focusedUser, not currentUser',
      build: build,
      act: (bloc) {
        userRepository.userResult = (_) => bob;
        bloc.add(const FetchUserById(2));
      },
      verify: (bloc) {
        expect(bloc.state.focusedUser, bob);
        expect(bloc.state.currentUser, isNull);
      },
    );

    blocTest<UserBloc, UserState>(
      'the current user lands in currentUser',
      build: build,
      act: (bloc) {
        userRepository.currentUser = alice;
        bloc.add(const FetchCurrentUser());
      },
      verify: (bloc) => expect(bloc.state.currentUser, alice),
    );
  });

  group('profile picture', () {
    blocTest<UserBloc, UserState>(
      'caches the fetched image against its user id',
      build: build,
      act: (bloc) => bloc.add(const FetchProfilePicture(null, 1)),
      verify: (bloc) {
        expect(bloc.state.profilePictures.containsKey(1), isTrue);
        expect(userRepository.calls, contains('getProfilePicture(null, 1)'));
      },
    );

    blocTest<UserBloc, UserState>(
      'reports failure rather than throwing when the image cannot load',
      build: build,
      act: (bloc) {
        userRepository.nextError = Exception('404');
        bloc.add(const FetchProfilePicture('https://cdn/x.jpg', 1));
      },
      expect: () => [
        isA<UserState>().having((s) => s.status, 'status', UserStatus.loading),
        isA<UserState>().having((s) => s.status, 'status', UserStatus.failure),
      ],
    );

    blocTest<UserBloc, UserState>(
      'updating a picture replaces the current user',
      build: build,
      seed: () => UserState(users: const [], currentUser: alice),
      act: (bloc) {
        userRepository.updateProfilePictureResult = bob;
        bloc.add(UpdateProfilePicture(
          PickedImage(bytes: Uint8List(0), name: 'pic.jpg'),
        ));
      },
      verify: (bloc) => expect(bloc.state.currentUser, bob),
    );
  });
}
