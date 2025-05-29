import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/data/repositories/store_repo.dart.dart';
import 'store_event.dart';
import 'store_state.dart';

class StoreBloc extends Bloc<StoreEvt, StoreState> {
  final ImagePicker _picker = ImagePicker();

  StoreBloc({required StoreRepository repo})
      : _repo = repo,
        super(const StoreState()) {
    on<CreateStoreButtonEvt>(_onCreateStore);
    on<AddProductButtonEvt>(_onAddProduct);
    on<EditProductButtonEvt>(_onEditProduct);
    on<DeleteProductEvt>(_onDeleteProduct);
    on<PickImageEvt>(_onPickImage);
    on<RemoveImageEvt>(_onRemoveImage);
    on<CreateStoreFormValidateChangedEvt>(_onCreateStoreFormValidateChanged);
    on<EditFormValidateChangedEvt>(_onEditFormValidateChanged);
    on<AddProductFormValidateChangedEvt>(_onAddProductFormValidateChanged);
    on<InitializeEditProductEvt>(_onInitializeEditProduct);
  }

  final StoreRepository _repo;

  Future<void> _onCreateStore(
    CreateStoreButtonEvt event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const StoreStatus.loading(),
      ),
    );
    try {
      final insertedStore = await _repo.createStore(event.store);

      emit(
        state.copyWith(
          hasStore: true,
          stores: insertedStore,
          status: const StoreStatus.success(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: const StoreStatus.failure(),
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCreateStoreFormValidateChanged(
    CreateStoreFormValidateChangedEvt event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        stores: event.store,
        isFormValid: event.isValidate,
      ),
    );
  }

  Future<void> _onAddProduct(
    AddProductButtonEvt event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const StoreStatus.loading(),
      ),
    );
    try {
      final createdProduct = await _repo.addProduct(event.product);

      final updatedProducts = List<ProductModel>.from(state.products ?? [])
        ..add(createdProduct);
      emit(
        state.copyWith(
          products: updatedProducts,
          hasProducts: true,
          status: const StoreStatus.success(),
          imageFiles: [],
          isProductAdded: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const StoreStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddProductFormValidateChanged(
    AddProductFormValidateChangedEvt event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        isFormValid: event.isValidate,
        products: event.products,
      ),
    );
  }

  Future<void> _onEditFormValidateChanged(
    EditFormValidateChangedEvt event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        isFormValid: event.isValidate,
      ),
    );
  }

  Future<void> _onEditProduct(
    EditProductButtonEvt event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const StoreStatus.loading(),
      ),
    );

    try {
      await _repo.editProduct(event.product);

      final updatedProducts = state.products?.map((product) {
        if (product.id == event.product.id) {
          return event.product;
        }
        return product;
      }).toList();

      emit(
        state.copyWith(
          products: updatedProducts,
          status: const StoreStatus.success(),
          imageFiles: [],
          productToEdit: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const StoreStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvt event,
    Emitter<StoreState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const StoreStatus.loading(),
      ),
    );
    try {
      await _repo.deleteProduct(event.productId);

      final updatedProducts = (state.products ?? [])
          .where((product) => product.id != event.productId)
          .toList();

      emit(
        state.copyWith(
          products: updatedProducts,
          hasProducts: updatedProducts.isNotEmpty,
          status: const StoreStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const StoreStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRemoveImage(
    RemoveImageEvt event,
    Emitter<StoreState> emit,
  ) async {
    final updatedImages = List<File>.from(
      state.imageFiles ?? [],
    )..removeAt(event.image);
    emit(
      state.copyWith(
        imageFiles: updatedImages,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onPickImage(
    PickImageEvt event,
    Emitter<StoreState> emit,
  ) async {
    final currentImageCount = state.imageFiles?.length ?? 0;

    if (currentImageCount >= event.maxPhotos) {
      emit(state.copyWith(
        errorMessage: 'Maximum ${event.maxPhotos} photos allowed',
      ));
      return;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();
        const maxFileSize = 5 * 1024 * 1024;

        if (fileSize > maxFileSize) {
          emit(state.copyWith(
            errorMessage: 'Image size should be less than 5MB',
          ));
          return;
        }

        final updatedImages = List<File>.from(state.imageFiles ?? [])
          ..add(file);

        emit(state.copyWith(
          imageFiles: updatedImages,
          errorMessage: null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to pick image: ${e.toString()}',
      ));
    }
  }

  Future<void> _onInitializeEditProduct(
    InitializeEditProductEvt event,
    Emitter<StoreState> emit,
  ) async {
    final imagePaths = event.product.imageUrl.split(',');
    final imageFiles = imagePaths.map((path) => File(path)).toList();

    emit(
      state.copyWith(
        productToEdit: event.product,
        imageFiles: imageFiles,
      ),
    );
  }
}
