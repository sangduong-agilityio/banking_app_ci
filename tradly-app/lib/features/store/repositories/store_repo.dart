import 'package:tradly_app/api/api_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/store/models/store_model.dart';

abstract class StoreRepository {
  Future<bool> hasStore();
  Future<StoreModel> createStore(StoreModel store);
  Future<ProductModel> addProduct(ProductModel product);
  Future<void> editProduct(ProductModel product);
  Future<void> deleteProduct(int productId);
}

class StoreRepositoryImpl implements StoreRepository {
  final TradlyApiClient _apiClient;

  StoreRepositoryImpl({required TradlyApiClient apiClient})
      : _apiClient = apiClient;

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<bool> hasStore() async {
    final response = await _apiClient.get('stores');
    return response.data.isNotEmpty;
  }

  @override
  Future<StoreModel> createStore(StoreModel store) async {
    try {
      final response = await _supabase
          .from('stores')
          .insert(store.toJson()
            ..remove('products')
            ..remove('tagLine'))
          .select()
          .single();

      return StoreModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create store: $e');
    }
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      final response = await _supabase
          .from('products')
          .insert(product.toJson()
            ..remove('id')
            ..remove('productType'))
          .select()
          .single();

      return ProductModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  @override
  Future<void> editProduct(ProductModel product) async {
    if (product.id == null) {
      throw Exception('Product ID is required for editing');
    }

    try {
      await _supabase
          .from('products')
          .update(product.toJson()..remove('productType'))
          .eq('id', product.id!)
          .select();
    } catch (e) {
      throw Exception('Failed to edit product: $e');
    }
  }

  @override
  Future<void> deleteProduct(int productId) async {
    try {
      await _supabase.from('products').delete().eq('id', productId);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
