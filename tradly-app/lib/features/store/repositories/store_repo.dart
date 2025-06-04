import 'package:tradly_app/api/api_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/store/models/store_model.dart';

abstract class StoreRepository {
  Future<bool> hasStore();
  Future<StoreModel> createStore(StoreModel store);
  Future<ProductModel> addProduct(ProductModel product);
  Future<void> editProduct(ProductModel product);
  Future<void> deleteProduct(int product);
}

class StoreRepositoryImpl implements StoreRepository {
  final TradlyApiClient _apiClient;

  StoreRepositoryImpl({required TradlyApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<bool> hasStore() async {
    final response = await _apiClient.get('stores');
    return response.data.isNotEmpty;
  }

  @override
  Future<StoreModel> createStore(StoreModel store) async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('stores')
        .insert({
          'storeName': store.storeName,
          'storeWebAddress': store.storeWebAddress,
          'storeDescription': store.storeDescription,
          'storeType': store.storeType,
          'imageUrl': store.imageUrl,
          'address': store.address,
          'city': store.city,
          'logoStore': store.logoStore,
          'country': store.country,
          'courieName': store.courieName,
        })
        .select()
        .single();

    return StoreModel.fromMap(response);
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('products')
          .insert({
            'title': product.title,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'brand': product.brand,
            'newPrice': product.newPrice,
            'description': product.description,
            'priceType': product.priceType,
            'condition': product.condition,
            'location': product.location,
            'storeId': product.storeId,
          })
          .select()
          .single();

      return ProductModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add product');
    }
  }

  @override
  Future<void> editProduct(ProductModel product) async {
    final supabase = Supabase.instance.client;

    await supabase
        .from('products')
        .update({
          'title': product.title,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'brand': product.brand,
          'newPrice': product.newPrice,
          'description': product.description,
          'priceType': product.priceType,
          'condition': product.condition,
          'location': product.location,
          'storeId': product.storeId,
        })
        .eq('id', product.id ?? 0)
        .select();
  }

  @override
  Future<void> deleteProduct(int productId) async {
    final supabase = Supabase.instance.client;
    await supabase.from('products').delete().eq('id', productId);
  }
}
