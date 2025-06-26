import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/features/profile/states/profile_cubit.dart';
import 'package:tradly_app/features/profile/states/profile_state.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/utils.dart';
import '../profile_mocks.dart';

void main() {
  late final repo = AuthRepositoryMock();
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    S.load(const Locale('en'));
  });

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
  });

  TABlocTest(
    description: 'ProfileCubit Tests',
    features: [
      TABlocTestFeature(
        description: 'FetchProfileEvt',
        scenarios: [
          FetchProfileEvtSuccessScenario(repo: repo),
          FetchProfileEvtFailureScenario(repo: repo),
        ],
      ),
    ],
  ).test();
}

class FetchProfileEvtSuccessScenario
    extends TABlocTestScenario<ProfileCubit, ProfileState> {
  FetchProfileEvtSuccessScenario({
    required AuthRepositoryMock repo,
  }) : super(
          description: '''
            Scenario: Test FetchProfileEvt emits success state with profile data
              Given ProfileCubit instance
              When FetchProfileEvt is added
              Then it should emit a success state with profile data
          ''',
          build: () => ProfileCubit(repo: repo),
          act: (bloc) {
            when(() => repo.getCurrentUser())
                .thenAnswer((_) async => ProfileMocks.user);
            bloc.fetchProfile();
          },
          expect: () => [
            isA<ProfileState>()
                .having((s) => s.status, 'status', ProfileStatus.loading()),
            isA<ProfileState>()
                .having((s) => s.status, 'status', ProfileStatus.success())
                .having((s) => s.user?.userName, 'userName',
                    ProfileMocks.user.userMetadata?['username'] ?? '')
                .having((s) => s.user?.email, 'email',
                    ProfileMocks.user.email ?? '')
                .having((s) => s.user?.phoneNumber, 'phoneNumber',
                    ProfileMocks.user.phone ?? ''),
          ],
        );
}

class FetchProfileEvtFailureScenario
    extends TABlocTestScenario<ProfileCubit, ProfileState> {
  FetchProfileEvtFailureScenario({
    required AuthRepositoryMock repo,
  }) : super(
          description: '''
            Scenario: Test FetchProfileEvt emits failure state when an error occurs
              Given ProfileCubit instance
              When FetchProfileEvt is added
              Then it should emit a failure state with an error message
          ''',
          build: () => ProfileCubit(repo: repo),
          act: (bloc) {
            when(() => repo.getCurrentUser())
                .thenThrow(Exception('Fetch error'));
            bloc.fetchProfile();
          },
          expect: () => [
            isA<ProfileState>()
                .having((s) => s.status, 'status', ProfileStatus.loading()),
            isA<ProfileState>()
                .having((s) => s.status, 'status', ProfileStatus.failure())
                .having((s) => s.errorMessage, 'errorMessage',
                    'Exception: Fetch error'),
          ],
        );
}
