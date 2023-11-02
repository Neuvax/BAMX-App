import "dart:async";

import 'package:bloc_test/bloc_test.dart';
import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/cubits/auth_cubit.dart';
import 'package:bamx_app/src/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepo mockRepo;

  setUp(() async {
    await getIt.reset();
    mockRepo = MockAuthRepo();
    getIt.registerSingleton<AuthRepository>(mockRepo);
  });

  blocTest<AuthCubit, CurrentAuthState>(
    'Signed out state will be emitted',
    build: () {
      when(() => mockRepo.onAuthStateChanged)
          .thenAnswer((_) => Stream.fromIterable([null]));
      return AuthCubit();
    },
    act: (cubit) async => await cubit.init(),
    expect: () => [
      const CurrentAuthState(Status.signedOut, null),
    ],
  );

  blocTest<AuthCubit, CurrentAuthState>(
    'Signed in state will be emitted',
    build: () {
      when(() => mockRepo.onAuthStateChanged)
          .thenAnswer((_) => Stream.fromIterable(['someUserID']));
      return AuthCubit();
    },
    act: (cubit) => cubit.init(),
    expect: () => [
      const CurrentAuthState(Status.signedIn, null),
    ],
  );

  blocTest<AuthCubit, CurrentAuthState>(
      'Signed out state will be emitted after calling signOut',
      build: () {
        when(() => mockRepo.onAuthStateChanged)
            .thenAnswer((_) => Stream.fromIterable(['someUserID']));
        when(() => mockRepo.signOut()).thenAnswer((_) async {});
        return AuthCubit();
      },
      act: (cubit) async {
        await cubit.init();
        await cubit.signOut();
      },
      expect: () => [
            const CurrentAuthState(Status.signedIn, null),
            const CurrentAuthState(Status.signedOut, null),
          ],
      verify: (cubit) {
        verify(() => mockRepo.signOut()).called(1);
      });
}
