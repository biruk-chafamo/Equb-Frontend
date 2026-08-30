import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/user_builder.dart';
import '../support/fakes/fake_user_repository.dart';

void main() {
  late FakeUserRepository userRepository;
  final alice = buildUser(id: 1, firstName: 'Alice');
  final picked = PickedImage(bytes: Uint8List.fromList([1, 2, 3]), name: 'a.jpg');

  UserBloc build() => UserBloc(userRepository: userRepository);

  setUp(() => userRepository = FakeUserRepository());

  group('uploading a profile picture', () {
    blocTest<UserBloc, UserState>(
      'reports progress and then the updated user',
      build: build,
      seed: () => UserState(users: const [], currentUser: alice),
      act: (bloc) => bloc.add(UpdateProfilePicture(picked)),
      expect: () => [
        isA<UserState>()
            .having((s) => s.isUploadingPicture, 'uploading', isTrue),
        isA<UserState>()
            .having((s) => s.isUploadingPicture, 'uploading', isFalse)
            .having((s) => s.pictureUploadError, 'error', isNull),
      ],
    );

    blocTest<UserBloc, UserState>(
      'a failed upload surfaces a message instead of going quiet',
      build: build,
      seed: () => UserState(users: const [], currentUser: alice),
      act: (bloc) {
        userRepository.nextError = DioException(
          requestOptions: RequestOptions(path: '/users/1/'),
          type: DioExceptionType.connectionTimeout,
        );
        bloc.add(UpdateProfilePicture(picked));
      },
      expect: () => [
        isA<UserState>()
            .having((s) => s.isUploadingPicture, 'uploading', isTrue),
        isA<UserState>()
            .having((s) => s.isUploadingPicture, 'uploading', isFalse)
            .having((s) => s.pictureUploadError, 'error', isNotNull),
      ],
    );

    blocTest<UserBloc, UserState>(
      'an upload does not disturb the status other screens gate on',
      build: build,
      seed: () => UserState(
          users: const [], currentUser: alice, status: UserStatus.success),
      act: (bloc) {
        userRepository.nextError = DioException(
          requestOptions: RequestOptions(path: '/users/1/'),
        );
        bloc.add(UpdateProfilePicture(picked));
      },
      // seven screens, including the always-visible nav rail, render on
      // UserStatus.success; a failed upload must not blank them
      verify: (bloc) => expect(bloc.state.status, UserStatus.success),
    );

    blocTest<UserBloc, UserState>(
      'a retry clears the previous error',
      build: build,
      seed: () => UserState(
        users: const [],
        currentUser: alice,
        pictureUploadError: 'Connection failed',
      ),
      act: (bloc) => bloc.add(UpdateProfilePicture(picked)),
      verify: (bloc) => expect(bloc.state.pictureUploadError, isNull),
    );
  });
}
