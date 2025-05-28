import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/data/models/user_model.dart';
import 'package:tradly_app/presentations/pages/profile/states/profile_state.dart';

import '../../helper/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  TAUnitTest(
    description: 'ProfileState Test',
    features: [
      TAUTFeature(
        description: 'ProfileState',
        scenarios: [
          ProfileStatePropsScenario(),
          ProfileStateEqualityScenario(),
          ProfileStateCopyWithScenario(),
          ProfileStateDefaultValuesScenario(),
          ProfileStateToStringScenario(),
          ProfileStateCopyWithStatusScenario(),
        ],
      ),
    ],
  ).test();
}

class ProfileStatePropsScenario
    extends TAUTScenario<ProfileState, ProfileState> {
  ProfileStatePropsScenario()
      : super(
          description: '''
           Scenario: Test ProfileState PropsScenario
            Given ProfileState instance
            When accessing props
            Then it should return the correct values
          ''',
          when: () async {
            return ProfileState(
              status: ProfileStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const ProfileStatus.success(),
          ),
          expect: (ProfileState result) {
            expect(
              result.status == const ProfileStatus.success(),
              isTrue,
            );
          },
        );
}

class ProfileStateEqualityScenario
    extends TAUTScenario<ProfileState, ProfileState> {
  ProfileStateEqualityScenario()
      : super(
          description: '''
           Scenario: Test ProfileState Equality
            Given two ProfileState instances with the same properties
            When checking for equality
            Then it should return true
          ''',
          when: () async {
            return ProfileState(
                status: ProfileStatus.success(),
                errorMessage: 'error',
                user: UserModel(
                  id: 1,
                  userName: 'username',
                  email: 'email',
                  phoneNumber: 'phone',
                ));
          },
          act: (result) => result,
          expect: (ProfileState result) {
            expect(result == result, isTrue);
          },
        );
}

class ProfileStateCopyWithScenario
    extends TAUTScenario<ProfileState, ProfileState> {
  ProfileStateCopyWithScenario()
      : super(
          description: '''
           Scenario: Test ProfileState CopyWithScenario
            Given two ProfileState instances
            When comparing them
            Then they should be equal
          ''',
          when: () {
            return ProfileState(
              status: ProfileStatus.initial(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: ProfileStatus.success(),
            errorMessage: 'new error',
          ),
          expect: (ProfileState result) {
            expect(result.status, const ProfileStatus.success());
            expect(result.errorMessage, 'new error');
          },
        );
}

class ProfileStateDefaultValuesScenario
    extends TAUTScenario<ProfileState, ProfileState> {
  ProfileStateDefaultValuesScenario()
      : super(
          description: '''
           Scenario: Test ProfileState DefaultValuesScenario
            Given ProfileState instance
            When accessing props
            Then it should return the correct values
          ''',
          when: () {
            return ProfileState();
          },
          act: (state) => state,
          expect: (ProfileState result) {
            expect(result.status, const ProfileStatus.initial());
            expect(result.errorMessage, isNull);
          },
        );
}

class ProfileStateToStringScenario extends TAUTScenario<ProfileState, String> {
  ProfileStateToStringScenario()
      : super(
          description: '''
           Scenario: Test ProfileState ToStringScenario
            Given ProfileState instance
            When accessing props
            Then it should return the correct values
          ''',
          when: () async {
            return ProfileState(
              status: ProfileStatus.success(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.toString(),
          expect: (String result) {
            expect(
                result, 'ProfileState(null, ProfileStatus.success(), error)');
          },
        );
}

class ProfileStateCopyWithStatusScenario
    extends TAUTScenario<ProfileState, ProfileState> {
  ProfileStateCopyWithStatusScenario()
      : super(
          description: '''
           Scenario: Test ProfileState CopyWithStatusScenario
            Given ProfileState instance
            When accessing props
            Then it should return the correct values
          ''',
          when: () {
            return ProfileState(
              status: ProfileStatus.initial(),
              errorMessage: 'error',
            );
          },
          act: (state) => state.copyWith(
            status: const ProfileStatus.loading(),
          ),
          expect: (ProfileState result) {
            expect(result.status, const ProfileStatus.loading());
          },
        );
}
