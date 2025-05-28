import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/data/repositories/auth_repo.dart';
import 'package:tradly_app/presentations/pages/profile/states/profile_bloc.dart';
import 'package:tradly_app/presentations/pages/profile/states/profile_event.dart';
import 'package:tradly_app/presentations/pages/profile/states/profile_state.dart';

import '../../helper/utils.dart';
import '../profile_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final authRepository = AuthRepositoryMock();

  setUp(() {
    S.load(const Locale('en'));
  });

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
  });

  TABlocTest(
    description: 'ProfileBloc Test',
    features: [
      TABlocTestFeature(
        description: 'ProfileInitializeEvt',
        scenarios: [
          ProfileInitializeSuccessScenario(
            authRepository: authRepository,
          ),
          ProfileInitializeFailureScenario(
            authRepository: authRepository,
          ),
          ProfileInitializeEmptyScenario(
            authRepository: authRepository,
          ),
        ],
      ),
    ],
  ).test();
}

class ProfileInitializeSuccessScenario
    extends TABlocTestScenario<ProfileBloc, ProfileState> {
  ProfileInitializeSuccessScenario({
    required AuthRepository authRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProfileBloc is initialized, the user details are fetched successfully
          Given: The ProfileBloc is created with a mock repository.
          When: The _onFetched method is called. 
          Then: The bloc should emit a HomeState with a status of success.
          ''',
          setUp: () {
            when(() => authRepository.getCurrentUser())
                .thenAnswer((_) => Future.value(ProfileMocks.user));
          },
          build: () => ProfileBloc(repo: authRepository),
          act: (bloc) => bloc.add(const FetchProfileEvt()),
          expect: () => [
            isA<ProfileState>().having(
              (state) => state.status,
              'loading status',
              const ProfileStatus.loading(),
            ),
            isA<ProfileState>().having(
              (state) => state.status,
              'success status',
              const ProfileStatus.success(),
            ),
          ],
        );
}

class ProfileInitializeEmptyScenario
    extends TABlocTestScenario<ProfileBloc, ProfileState> {
  ProfileInitializeEmptyScenario({
    required AuthRepository authRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProfileBloc is initialized, the user details are fetched 
          Given: The ProfileBloc is created with a mock repository.
          When: The _onFetched method is called. 
          Then: The bloc should emit a ProfileBloc  with a status .
          ''',
          setUp: () {
            when(() => authRepository.getCurrentUser())
                .thenAnswer((_) => Future.value(null));
          },
          build: () => ProfileBloc(repo: authRepository),
          act: (bloc) => bloc.add(const FetchProfileEvt()),
          expect: () => [
            isA<ProfileState>().having(
              (state) => state.status,
              'loading status',
              const ProfileStatus.loading(),
            ),
            isA<ProfileState>().having(
              (state) => state.status,
              'success status',
              const ProfileStatus.success(),
            ),
          ],
        );
}

class ProfileInitializeFailureScenario
    extends TABlocTestScenario<ProfileBloc, ProfileState> {
  ProfileInitializeFailureScenario({
    required AuthRepository authRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the ProfileBloc is initialized, the user details are fetched failure
          Given: The ProfileBloc is created with a mock repository.
          When: The _onFetched method is called. 
          Then: The bloc should emit a ProfileBloc  with a status of failure.
          ''',
          setUp: () {
            when(() => authRepository.getCurrentUser()).thenThrow(Exception());
          },
          build: () => ProfileBloc(repo: authRepository),
          act: (bloc) => bloc.add(const FetchProfileEvt()),
          expect: () => [
            isA<ProfileState>().having(
              (state) => state.status,
              'loading status',
              const ProfileStatus.loading(),
            ),
            isA<ProfileState>().having(
              (state) => state.status,
              'success status',
              const ProfileStatus.failure(),
            ),
          ],
        );
}
