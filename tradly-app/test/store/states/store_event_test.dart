import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/pages/store/states/store_event.dart';

import '../../helper/utils.dart';
import '../store_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
    await S.load(const Locale('en'));
  });

  TAUnitTest(
    description: 'StoreEvt Test',
    features: [
      TAUTFeature(
        description: 'StoreEvt',
        scenarios: [
          StoreEvtPropsScenario(),
        ],
      ),
      TAUTFeature(
        description: 'InitializeStoreEvt',
        scenarios: [
          InitializeStoreEvtPropsScenario(),
          InitializeStoreEvtWithToStringScenario(),
          InitializeStoreEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'CreateStoreButtonEvt',
        scenarios: [
          CreateStoreButtonEvtScenario(),
          CreateStoreButtonEvtWithToStringScenario(),
          CreateStoreButtonEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'CreateStoreFormValidateChangedEvt',
        scenarios: [
          CreateStoreFormValidateChangedEvtPropsScenario(),
          CreateStoreFormValidateChangedEvtWithToStringScenario(),
          CreateStoreFormValidateChangedEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'AddProductEvt',
        scenarios: [
          AddProductEvtPropsScenario(),
          AddProductEvtWithToStringScenario(),
          AddProductEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'AddProductFormValidateChangedEvt',
        scenarios: [
          AddProductFormValidateChangedEvtPropsScenario(),
          AddProductFormValidateChangedEvtWithToStringScenario(),
          AddProductFormValidateChangedEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'EditProductButtonEvt',
        scenarios: [
          EditProductButtonEvtPropsScenario(),
          EditProductButtonEvtWithToStringScenario(),
          EditProductButtonEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'EditFormValidateChangedEvt',
        scenarios: [
          EditFormValidateChangedEvtPropsScenario(),
          EditFormValidateChangedEvtWithToStringScenario(),
          EditFormValidateChangedEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'DeleteProductEvt',
        scenarios: [
          DeleteProductEvtPropsScenario(),
          DeleteProductEvtWithToStringScenario(),
          DeleteProductEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'PickImageEvt',
        scenarios: [
          PickImageEvtPropsScenario(),
          PickImageEvtWithToStringScenario(),
          PickImageEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'RemoveImageEvt',
        scenarios: [
          RemoveImageEvtEvtPropsScenario(),
          RemoveImageEvtEvtWithToStringScenario(),
          RemoveImageEvtEvtEqualityScenario(),
        ],
      ),
      TAUTFeature(
        description: 'InitializeEditProductEvt',
        scenarios: [
          InitializeEditProductEvtPropsScenario(),
          InitializeEditProductEvtWithToStringScenario(),
          InitializeEditProductEvtEqualityScenario(),
        ],
      ),
    ],
  ).test();
}

class StoreEvtPropsScenario extends TAUTScenario<StoreEvt, List<Object?>> {
  StoreEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test StoreEvt Props
            Given StoreEvt event
            When creating a StoreEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return StoreEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, isEmpty);
          },
        );
}

class InitializeStoreEvtPropsScenario
    extends TAUTScenario<InitializeStoreEvt, List<Object?>> {
  InitializeStoreEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test InitializeStoreEvt Props
            Given InitializeStoreEvt event
            When creating a InitializeStoreEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return InitializeStoreEvt();
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, isEmpty);
          },
        );
}

class InitializeStoreEvtWithToStringScenario
    extends TAUTScenario<InitializeStoreEvt, String> {
  InitializeStoreEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test InitializeStoreEvt with toString
            Given InitializeStoreEvt event
            When creating a InitializeStoreEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return InitializeStoreEvt();
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class InitializeStoreEvtEqualityScenario
    extends TAUTScenario<InitializeStoreEvt, bool> {
  InitializeStoreEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test InitializeStoreEvt Equality
            Given InitializeStoreEvt event
            When creating a InitializeStoreEvt event and comparing with another InitializeStoreEvt event
            Then the events should be equal
            ''',
          when: () async {
            return InitializeStoreEvt();
          },
          act: (event) => event == InitializeStoreEvt(),
          expect: (bool result) {
            expect(result, true);
          },
        );
}

class CreateStoreButtonEvtScenario
    extends TAUTScenario<CreateStoreButtonEvt, List<Object?>> {
  CreateStoreButtonEvtScenario()
      : super(
          description: '''
          Scenario: Test CreateStoreButtonEvt Props
            Given CreateStoreButtonEvt event
            When creating a CreateStoreButtonEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return CreateStoreButtonEvt(store: StoreMocks.store);
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [StoreMocks.store]);
          },
        );
}

class CreateStoreButtonEvtWithToStringScenario
    extends TAUTScenario<CreateStoreButtonEvt, String> {
  CreateStoreButtonEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test CreateStoreButtonEvt with toString
            Given CreateStoreButtonEvt event
            When creating a CreateStoreButtonEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return CreateStoreButtonEvt(store: StoreMocks.store);
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class CreateStoreButtonEvtEqualityScenario
    extends TAUTScenario<CreateStoreButtonEvt, bool> {
  CreateStoreButtonEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test CreateStoreButtonEvt Equality
            Given CreateStoreButtonEvt event
            When creating a CreateStoreButtonEvt event and comparing with another CreateStoreButtonEvt event
            Then the events should be equal
            ''',
          when: () async {
            return CreateStoreButtonEvt(store: StoreMocks.store);
          },
          act: (event) =>
              event == CreateStoreButtonEvt(store: StoreMocks.store),
          expect: (bool result) {
            expect(result, true);
          },
        );
}

class CreateStoreFormValidateChangedEvtPropsScenario
    extends TAUTScenario<CreateStoreFormValidateChangedEvt, List<Object?>> {
  CreateStoreFormValidateChangedEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test CreateStoreFormValidateChangedEvt Props
            Given CreateStoreFormValidateChangedEvt event
            When creating a CreateStoreFormValidateChangedEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return CreateStoreFormValidateChangedEvt(
                store: StoreMocks.store, isValidate: true);
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [true, StoreMocks.store]);
          },
        );
}

class CreateStoreFormValidateChangedEvtWithToStringScenario
    extends TAUTScenario<CreateStoreFormValidateChangedEvt, String> {
  CreateStoreFormValidateChangedEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test CreateStoreFormValidateChangedEvt with toString
            Given CreateStoreFormValidateChangedEvt event
            When creating a CreateStoreFormValidateChangedEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return CreateStoreFormValidateChangedEvt(
                store: StoreMocks.store, isValidate: true);
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class CreateStoreFormValidateChangedEvtEqualityScenario
    extends TAUTScenario<CreateStoreFormValidateChangedEvt, bool> {
  CreateStoreFormValidateChangedEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test CreateStoreFormValidateChangedEvt Equality
            Given CreateStoreFormValidateChangedEvt event
            When creating a CreateStoreFormValidateChangedEvt event and comparing with another CreateStoreFormValidateChangedEvt event
            Then the events should be equal
            ''',
          when: () async {
            return CreateStoreFormValidateChangedEvt(
                store: StoreMocks.store, isValidate: true);
          },
          act: (event) =>
              event ==
              CreateStoreFormValidateChangedEvt(
                  store: StoreMocks.store, isValidate: true),
          expect: (bool result) {
            expect(result, true);
          },
        );
}

class AddProductEvtPropsScenario
    extends TAUTScenario<AddProductButtonEvt, List<Object?>> {
  AddProductEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test AddProductEvt Props
            Given AddProductEvt event
            When creating a AddProductEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return AddProductButtonEvt(product: StoreMocks.product);
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [StoreMocks.product]);
          },
        );
}

class AddProductEvtWithToStringScenario
    extends TAUTScenario<AddProductButtonEvt, String> {
  AddProductEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test AddProductEvt with toString
            Given AddProductEvt event
            When creating a AddProductEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return AddProductButtonEvt(product: StoreMocks.product);
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class AddProductEvtEqualityScenario
    extends TAUTScenario<AddProductButtonEvt, bool> {
  AddProductEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test AddProductEvt Equality
            Given AddProductEvt event
            When creating a AddProductEvt event and comparing with another AddProductEvt event
            Then the events should be equal
            ''',
          when: () async {
            return AddProductButtonEvt(product: StoreMocks.product);
          },
          act: (event) =>
              event == AddProductButtonEvt(product: StoreMocks.product),
          expect: (bool result) {
            expect(result, true);
          },
        );
}

class AddProductFormValidateChangedEvtPropsScenario
    extends TAUTScenario<AddProductFormValidateChangedEvt, List<Object?>> {
  AddProductFormValidateChangedEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test AddProductFormValidateChangedEvt Props
            Given AddProductFormValidateChangedEvt event
            When creating a AddProductFormValidateChangedEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return AddProductFormValidateChangedEvt(
                isValidate: true, products: [StoreMocks.product]);
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [
              [StoreMocks.product],
              true
            ]);
          },
        );
}

class AddProductFormValidateChangedEvtWithToStringScenario
    extends TAUTScenario<AddProductFormValidateChangedEvt, String> {
  AddProductFormValidateChangedEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test AddProductFormValidateChangedEvt with toString
            Given AddProductFormValidateChangedEvt event
            When creating a AddProductFormValidateChangedEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return AddProductFormValidateChangedEvt(
                isValidate: true, products: [StoreMocks.product]);
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class AddProductFormValidateChangedEvtEqualityScenario
    extends TAUTScenario<AddProductFormValidateChangedEvt, bool> {
  AddProductFormValidateChangedEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test AddProductFormValidateChangedEvt Equality
            Given AddProductFormValidateChangedEvt event
            When creating a AddProductFormValidateChangedEvt event and comparing with another AddProductFormValidateChangedEvt event
            Then the events should be equal
            ''',
          when: () async {
            return AddProductFormValidateChangedEvt(
                isValidate: true, products: [StoreMocks.product]);
          },
          act: (event) =>
              event ==
              AddProductFormValidateChangedEvt(
                  isValidate: true, products: [StoreMocks.product]),
          expect: (bool result) {
            expect(result, true);
          },
        );
}

class EditProductButtonEvtPropsScenario
    extends TAUTScenario<EditProductButtonEvt, List<Object?>> {
  EditProductButtonEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test EditProductButtonEvt Props
            Given EditProductButtonEvt event
            When creating a EditProductButtonEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return EditProductButtonEvt(product: StoreMocks.product);
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [StoreMocks.product]);
          },
        );
}

class EditProductButtonEvtWithToStringScenario
    extends TAUTScenario<EditProductButtonEvt, String> {
  EditProductButtonEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test EditProductButtonEvt with toString
            Given EditProductButtonEvt event
            When creating a EditProductButtonEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return EditProductButtonEvt(product: StoreMocks.product);
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class EditProductButtonEvtEqualityScenario
    extends TAUTScenario<EditProductButtonEvt, bool> {
  EditProductButtonEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test EditProductButtonEvt Equality
            Given EditProductButtonEvt event
            When creating a EditProductButtonEvt event and comparing with another EditProductButtonEvt event
            Then the events should be equal
            ''',
          when: () async {
            return EditProductButtonEvt(product: StoreMocks.product);
          },
          act: (event) =>
              event == EditProductButtonEvt(product: StoreMocks.product),
          expect: (bool result) {
            expect(result, true);
          },
        );
}

class EditFormValidateChangedEvtPropsScenario
    extends TAUTScenario<EditFormValidateChangedEvt, List<Object?>> {
  EditFormValidateChangedEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test EditFormValidateChangedEvt Props
            Given EditFormValidateChangedEvt event
            When creating a EditFormValidateChangedEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return EditFormValidateChangedEvt(
              isValidate: true,
              product: StoreMocks.product,
            );
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [true, StoreMocks.product]);
          },
        );
}

class EditFormValidateChangedEvtWithToStringScenario
    extends TAUTScenario<EditFormValidateChangedEvt, String> {
  EditFormValidateChangedEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test EditFormValidateChangedEvt with toString
            Given EditFormValidateChangedEvt event
            When creating a EditFormValidateChangedEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return EditFormValidateChangedEvt(
              isValidate: true,
              product: StoreMocks.product,
            );
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class EditFormValidateChangedEvtEqualityScenario
    extends TAUTScenario<EditFormValidateChangedEvt, bool> {
  EditFormValidateChangedEvtEqualityScenario()
      : super(
            description: '''
          Scenario: Test EditFormValidateChangedEvt Equality
            Given EditFormValidateChangedEvt event
            When creating a EditFormValidateChangedEvt event and comparing with another EditFormValidateChangedEvt event
            Then the events should be equal
            ''',
            when: () async {
              return EditFormValidateChangedEvt(
                isValidate: true,
                product: StoreMocks.product,
              );
            },
            act: (event) =>
                event ==
                EditFormValidateChangedEvt(
                  isValidate: true,
                  product: StoreMocks.product,
                ),
            expect: (bool result) {
              expect(result, true);
            });
}

class DeleteProductEvtPropsScenario
    extends TAUTScenario<DeleteProductEvt, List<Object?>> {
  DeleteProductEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test DeleteProductEvt Props
            Given DeleteProductEvt event
            When creating a DeleteProductEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return DeleteProductEvt(productId: 1);
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [1]);
          },
        );
}

class DeleteProductEvtWithToStringScenario
    extends TAUTScenario<DeleteProductEvt, String> {
  DeleteProductEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test DeleteProductEvt with toString
            Given DeleteProductEvt event
            When creating a DeleteProductEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return DeleteProductEvt(productId: 1);
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class DeleteProductEvtEqualityScenario
    extends TAUTScenario<DeleteProductEvt, bool> {
  DeleteProductEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test DeleteProductEvt Equality
            Given DeleteProductEvt event
            When creating a DeleteProductEvt event and comparing with another DeleteProductEvt event
            Then the events should be equal
            ''',
          when: () async {
            return DeleteProductEvt(productId: 1);
          },
          act: (event) => event == DeleteProductEvt(productId: 1),
          expect: (bool result) {
            expect(result, true);
          },
        );
}

class PickImageEvtPropsScenario
    extends TAUTScenario<PickImageEvt, List<Object?>> {
  PickImageEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test PickImageEvt Props
            Given PickImageEvt event
            When creating a PickImageEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return PickImageEvt(
              maxPhotos: 1,
            );
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [1]);
          },
        );
}

class PickImageEvtWithToStringScenario
    extends TAUTScenario<PickImageEvt, String> {
  PickImageEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test PickImageEvt with toString
            Given PickImageEvt event
            When creating a PickImageEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return PickImageEvt(
              maxPhotos: 1,
            );
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class PickImageEvtEqualityScenario extends TAUTScenario<PickImageEvt, bool> {
  PickImageEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test PickImageEvt Equality
            Given PickImageEvt event
            When creating a PickImageEvt event and comparing with another PickImageEvt event
            Then the events should be equal
            ''',
          when: () async {
            return PickImageEvt(
              maxPhotos: 1,
            );
          },
          act: (event) =>
              event ==
              PickImageEvt(
                maxPhotos: 1,
              ),
          expect: (bool result) {
            expect(result, true);
          },
        );
}

class RemoveImageEvtEvtPropsScenario
    extends TAUTScenario<RemoveImageEvt, List<Object?>> {
  RemoveImageEvtEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test RemoveImageEvt Props
            Given RemoveImageEvt event
            When creating a RemoveImageEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return RemoveImageEvt(image: 1);
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [1]);
          },
        );
}

class RemoveImageEvtEvtWithToStringScenario
    extends TAUTScenario<RemoveImageEvt, String> {
  RemoveImageEvtEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test RemoveImageEvt with toString
            Given RemoveImageEvt event
            When creating a RemoveImageEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return RemoveImageEvt(image: 1);
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class RemoveImageEvtEvtEqualityScenario
    extends TAUTScenario<RemoveImageEvt, bool> {
  RemoveImageEvtEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test RemoveImageEvt Equality
            Given RemoveImageEvt event
            When creating a RemoveImageEvt event and comparing with another RemoveImageEvt event
            Then the events should be equal
            ''',
          when: () async {
            return RemoveImageEvt(image: 1);
          },
          act: (event) => event == RemoveImageEvt(image: 1),
          expect: (bool result) {
            expect(result, true);
          },
        );
}

class InitializeEditProductEvtPropsScenario
    extends TAUTScenario<InitializeEditProductEvt, List<Object?>> {
  InitializeEditProductEvtPropsScenario()
      : super(
          description: '''
          Scenario: Test InitializeEditProductEvt Props
            Given InitializeEditProductEvt event
            When creating a InitializeEditProductEvt event and accessing props
            Then the props should be empty
            ''',
          when: () async {
            return InitializeEditProductEvt(product: StoreMocks.product);
          },
          act: (event) => event.props,
          expect: (List<Object?> result) {
            expect(result, [StoreMocks.product]);
          },
        );
}

class InitializeEditProductEvtWithToStringScenario
    extends TAUTScenario<InitializeEditProductEvt, String> {
  InitializeEditProductEvtWithToStringScenario()
      : super(
          description: '''
          Scenario: Test InitializeEditProductEvt with toString
            Given InitializeEditProductEvt event
            When creating a InitializeEditProductEvt event and accessing toString
            Then the toString should not be empty
            ''',
          when: () async {
            return InitializeEditProductEvt(product: StoreMocks.product);
          },
          act: (event) => event.toString(),
          expect: (String result) {
            expect(result, isNotEmpty);
          },
        );
}

class InitializeEditProductEvtEqualityScenario
    extends TAUTScenario<InitializeEditProductEvt, bool> {
  InitializeEditProductEvtEqualityScenario()
      : super(
          description: '''
          Scenario: Test InitializeEditProductEvt Equality
            Given InitializeEditProductEvt event
            When creating a InitializeEditProductEvt event and comparing with another InitializeEditProductEvt event
            Then the events should be equal
            ''',
          when: () async {
            return InitializeEditProductEvt(product: StoreMocks.product);
          },
          act: (event) =>
              event == InitializeEditProductEvt(product: StoreMocks.product),
          expect: (bool result) {
            expect(result, true);
          },
        );
}
