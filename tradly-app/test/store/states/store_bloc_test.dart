import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/data/repositories/store_repo.dart.dart';
import 'package:tradly_app/presentations/pages/store/states/store_bloc.dart';
import 'package:tradly_app/presentations/pages/store/states/store_event.dart';
import 'package:tradly_app/presentations/pages/store/states/store_state.dart';

import '../../helper/utils.dart';
import '../store_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final storeRepository = StoreRepositoryMocks();
  late final mockImagePicker = MockImagePicker();

  setUp(() {
    S.load(const Locale('en'));
  });

  setUpAll(() async {
    await S.delegate.load(const Locale('en'));
  });

  TABlocTest(
    description: 'StoreBloc Test',
    features: [
      TABlocTestFeature(
        description: 'CreateStoreButtonEvt',
        scenarios: [
          CreateStoreButtonEvtSuccessScenario(
            storeRepository: storeRepository,
          ),
          CreateStoreButtonEvtFailureScenario(
            storeRepository: storeRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'AddProductButtonEvt',
        scenarios: [
          AddProductButtonEvtSuccessScenario(
            storeRepository: storeRepository,
          ),
          AddProductButtonEvtFailureScenario(
            storeRepository: storeRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'EditProductButtonEvt',
        scenarios: [
          EditProductButtonEvtSuccessScenario(
            storeRepository: storeRepository,
          ),
          EditProductButtonEvtFailureScenario(
            storeRepository: storeRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'DeleteProductButtonEvt',
        scenarios: [
          DeleteProductButtonEvtSuccessScenario(
            storeRepository: storeRepository,
          ),
          DeleteProductButtonEvtFailureScenario(
            storeRepository: storeRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'PickImageEvt',
        scenarios: [
          PickImageEvtSuccessScenario(
            storeRepository: storeRepository,
            mockImagePicker: mockImagePicker,
          ),
          PickImageEvtFailureScenario(
            storeRepository: storeRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'CreateStoreFormValidateChangedEvt',
        scenarios: [
          CreateStoreFormValidateChangedEvtSuccessScenario(
            storeRepository: storeRepository,
          ),
          CreateStoreFormValidateChangedEvtFailureScenario(
            storeRepository: storeRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'EditFormValidateChangedEvt',
        scenarios: [
          EditFormValidateChangedEvtSuccessScenario(
            storeRepository: storeRepository,
          ),
          EditFormValidateChangedEvtFailureScenario(
            storeRepository: storeRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'AddProductFormValidateChangedEvt',
        scenarios: [
          AddProductFormValidateChangedEvtSuccessScenario(
            storeRepository: storeRepository,
          ),
          AddProductFormValidateChangedEvtFailureScenario(
            storeRepository: storeRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'InitializeEditProductEvt',
        scenarios: [
          InitializeEditProductEvtSuccessScenario(
            storeRepository: storeRepository,
          ),
          InitializeEditProductEvtFailureScenario(
            storeRepository: storeRepository,
          ),
        ],
      ),
      TABlocTestFeature(
        description: 'RemoveImageEvt',
        scenarios: [
          RemoveImageEvtSuccessScenario(
            storeRepository: storeRepository,
          ),
          RemoveImageEvtFailureScenario(
            storeRepository: storeRepository,
          ),
        ],
      ),
    ],
  ).test();
}

class CreateStoreButtonEvtSuccessScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  CreateStoreButtonEvtSuccessScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, create store success
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {
            when(() => storeRepository.createStore(
                  StoreMocks.store,
                )).thenAnswer(
              (_) async => StoreMocks.store,
            );
          },
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            CreateStoreButtonEvt(
              store: StoreMocks.store,
            ),
          ),
          expect: () => [
            isA<StoreState>().having(
              (state) => state.status,
              'loading status',
              const StoreStatus.loading(),
            ),
            isA<StoreState>().having(
              (state) => state.status,
              'success status',
              const StoreStatus.success(),
            ),
          ],
        );
}

class CreateStoreButtonEvtFailureScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  CreateStoreButtonEvtFailureScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, create store failure
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {
            when(() => storeRepository.createStore(
                  StoreMocks.store,
                )).thenThrow(
              Exception(),
            );
          },
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            CreateStoreButtonEvt(
              store: StoreMocks.store,
            ),
          ),
          expect: () => [
            isA<StoreState>().having(
              (state) => state.status,
              'loading status',
              const StoreStatus.loading(),
            ),
            isA<StoreState>().having(
              (state) => state.status,
              'failure status',
              const StoreStatus.failure(),
            ),
          ],
        );
}

class AddProductButtonEvtSuccessScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  AddProductButtonEvtSuccessScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, add product success
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {
            when(() => storeRepository.addProduct(
                  StoreMocks.product,
                )).thenAnswer(
              (_) async => StoreMocks.product,
            );
          },
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            AddProductButtonEvt(
              product: StoreMocks.product,
            ),
          ),
          expect: () => [
            isA<StoreState>().having(
              (state) => state.status,
              'loading status',
              const StoreStatus.loading(),
            ),
            isA<StoreState>().having(
              (state) => state.status,
              'success status',
              const StoreStatus.success(),
            ),
          ],
        );
}

class AddProductButtonEvtFailureScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  AddProductButtonEvtFailureScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, add product failure
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {
            when(() => storeRepository.addProduct(
                  StoreMocks.product,
                )).thenThrow(
              Exception(),
            );
          },
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            AddProductButtonEvt(
              product: StoreMocks.product,
            ),
          ),
          expect: () => [
            isA<StoreState>().having(
              (state) => state.status,
              'loading status',
              const StoreStatus.loading(),
            ),
            isA<StoreState>().having(
              (state) => state.status,
              'failure status',
              const StoreStatus.failure(),
            ),
          ],
        );
}

class EditProductButtonEvtSuccessScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  EditProductButtonEvtSuccessScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, edit product success
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {
            when(() => storeRepository.editProduct(
                  StoreMocks.product,
                )).thenAnswer(
              (_) async => StoreMocks.product,
            );
          },
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            EditProductButtonEvt(
              product: StoreMocks.product,
            ),
          ),
          expect: () => [
            isA<StoreState>().having(
              (state) => state.status,
              'loading status',
              const StoreStatus.loading(),
            ),
            isA<StoreState>().having(
              (state) => state.status,
              'success status',
              const StoreStatus.success(),
            ),
          ],
        );
}

class EditProductButtonEvtFailureScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  EditProductButtonEvtFailureScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, edit product failure
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {
            when(() => storeRepository.editProduct(
                  StoreMocks.product,
                )).thenThrow(
              Exception(),
            );
          },
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            EditProductButtonEvt(
              product: StoreMocks.product,
            ),
          ),
          expect: () => [
            isA<StoreState>().having(
              (state) => state.status,
              'loading status',
              const StoreStatus.loading(),
            ),
            isA<StoreState>().having(
              (state) => state.status,
              'failure status',
              const StoreStatus.failure(),
            ),
          ],
        );
}

class DeleteProductButtonEvtSuccessScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  DeleteProductButtonEvtSuccessScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, delete product success
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {
            when(() => storeRepository.deleteProduct(1)).thenAnswer(
              (_) async => StoreMocks.product,
            );
          },
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            DeleteProductEvt(productId: 1),
          ),
          expect: () => [
            isA<StoreState>().having(
              (state) => state.status,
              'loading status',
              const StoreStatus.loading(),
            ),
            isA<StoreState>().having(
              (state) => state.status,
              'success status',
              const StoreStatus.success(),
            ),
          ],
        );
}

class DeleteProductButtonEvtFailureScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  DeleteProductButtonEvtFailureScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, delete product failure
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {
            when(() => storeRepository.deleteProduct(1)).thenThrow(
              Exception(),
            );
          },
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            DeleteProductEvt(productId: 1),
          ),
          expect: () => [
            isA<StoreState>().having(
              (state) => state.status,
              'loading status',
              const StoreStatus.loading(),
            ),
            isA<StoreState>().having(
              (state) => state.status,
              'failure status',
              const StoreStatus.failure(),
            ),
          ],
        );
}

class PickImageEvtSuccessScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  PickImageEvtSuccessScenario({
    required StoreRepository storeRepository,
    required MockImagePicker mockImagePicker,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, pick image success
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {
            mockImagePicker = MockImagePicker();
            when(() => mockImagePicker.pickImage(
                  source: ImageSource.gallery,
                )).thenAnswer(
              (_) async => XFile(
                'path',
                name: 'name',
              ),
            );
          },
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            PickImageEvt(maxPhotos: 1),
          ),
          expect: () => [],
        );
}

class PickImageEvtFailureScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  PickImageEvtFailureScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, pick image failure
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {},
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            PickImageEvt(maxPhotos: 1),
          ),
          expect: () => [],
        );
}

class RemoveImageEvtSuccessScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  RemoveImageEvtSuccessScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, remove image success
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {},
          build: () => StoreBloc(repo: storeRepository),
          seed: () => StoreState(
            imageFiles: [
              File('path/to/image1.jpg'),
              File('path/to/image2.jpg'),
              File('path/to/image3.jpg'),
            ],
          ),
          act: (bloc) => bloc.add(
            RemoveImageEvt(image: 1),
          ),
          expect: () => [
            isA<StoreState>().having(
              (state) => state.status,
              'StoreStatus.initial status',
              const StoreStatus.initial(),
            ),
          ],
        );
}

class RemoveImageEvtFailureScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  RemoveImageEvtFailureScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, remove image failure
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {},
          build: () => StoreBloc(repo: storeRepository),
          seed: () => StoreState(
            imageFiles: [
              File('path/to/image1.jpg'),
              File('path/to/image2.jpg'),
              File('path/to/image3.jpg'),
            ],
          ),
          act: (bloc) => bloc.add(RemoveImageEvt(image: 1)),
          expect: () => [
            isA<StoreState>().having(
              (state) => state.status,
              'StoreStatus.initial status',
              const StoreStatus.initial(),
            ),
          ],
        );
}

class CreateStoreFormValidateChangedEvtSuccessScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  CreateStoreFormValidateChangedEvtSuccessScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, create store form validate changed success
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {},
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            CreateStoreFormValidateChangedEvt(isValidate: true),
          ),
          expect: () => [
            StoreState(
              errorMessage: null,
              status: StoreStatus.initial(),
              stores: null,
              hasStore: false,
              products: null,
              hasProducts: false,
              imageFiles: null,
              productToEdit: null,
              isProductAdded: false,
              isFormValid: true,
            )
          ],
        );
}

class CreateStoreFormValidateChangedEvtFailureScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  CreateStoreFormValidateChangedEvtFailureScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, create store form validate changed failure
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {},
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            CreateStoreFormValidateChangedEvt(isValidate: false),
          ),
          expect: () => [
            StoreState(
              errorMessage: null,
              status: StoreStatus.initial(),
              stores: null,
              hasStore: false,
              products: null,
              hasProducts: false,
              imageFiles: null,
              productToEdit: null,
              isProductAdded: false,
              isFormValid: false,
            )
          ],
        );
}

class AddProductFormValidateChangedEvtSuccessScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  AddProductFormValidateChangedEvtSuccessScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, add product form validate changed success
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {},
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            AddProductFormValidateChangedEvt(isValidate: true),
          ),
          expect: () => [
            StoreState(
              errorMessage: null,
              status: StoreStatus.initial(),
              stores: null,
              hasStore: false,
              products: null,
              hasProducts: false,
              imageFiles: null,
              productToEdit: null,
              isProductAdded: false,
              isFormValid: true,
            )
          ],
        );
}

class AddProductFormValidateChangedEvtFailureScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  AddProductFormValidateChangedEvtFailureScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, add product form validate changed failure
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {},
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            AddProductFormValidateChangedEvt(isValidate: false),
          ),
          expect: () => [
            StoreState(
              errorMessage: null,
              status: StoreStatus.initial(),
              stores: null,
              hasStore: false,
              products: null,
              hasProducts: false,
              imageFiles: null,
              productToEdit: null,
              isProductAdded: false,
              isFormValid: false,
            )
          ],
        );
}

class EditFormValidateChangedEvtSuccessScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  EditFormValidateChangedEvtSuccessScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, edit form validate changed success
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {},
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            EditFormValidateChangedEvt(
                isValidate: true, product: StoreMocks.product),
          ),
          expect: () => [
            StoreState(
              errorMessage: null,
              status: StoreStatus.initial(),
              stores: null,
              hasStore: false,
              products: null,
              hasProducts: false,
              imageFiles: null,
              productToEdit: null,
              isProductAdded: false,
              isFormValid: true,
            )
          ],
        );
}

class EditFormValidateChangedEvtFailureScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  EditFormValidateChangedEvtFailureScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, edit form validate changed failure
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          setUp: () {},
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            EditFormValidateChangedEvt(
                isValidate: false, product: StoreMocks.product),
          ),
          expect: () => [
            StoreState(
              errorMessage: null,
              status: StoreStatus.initial(),
              stores: null,
              hasStore: false,
              products: null,
              hasProducts: false,
              imageFiles: null,
              productToEdit: null,
              isProductAdded: false,
              isFormValid: false,
            )
          ],
        );
}

class InitializeEditProductEvtSuccessScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  InitializeEditProductEvtSuccessScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, initialize edit product success
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            InitializeEditProductEvt(product: StoreMocks.product),
          ),
          expect: () => [
            isA<StoreState>().having(
              (state) => state.status,
              'StoreStatus.initial status',
              const StoreStatus.initial(),
            ),
          ],
        );
}

class InitializeEditProductEvtFailureScenario
    extends TABlocTestScenario<StoreBloc, StoreState> {
  InitializeEditProductEvtFailureScenario({
    required StoreRepository storeRepository,
  }) : super(
          description: '''
         Scenario: Ensure that when the StoreBloc is initialized, initialize edit product failure
          Given: The StoreBloc is created with a mock repository.
          When: The _onInitialize method is called. 
          Then: The bloc should emit a StoreState with a status of failure.
          ''',
          build: () => StoreBloc(repo: storeRepository),
          act: (bloc) => bloc.add(
            InitializeEditProductEvt(product: StoreMocks.product),
          ),
          expect: () => [
            isA<StoreState>().having(
              (state) => state.status,
              'StoreStatus.initial status',
              const StoreStatus.initial(),
            ),
          ],
        );
}
