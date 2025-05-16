import 'package:tradly_app/core/api/api_client.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/data/models/store_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class StoreRepository {
  Future<bool> hasStore();
  Future<void> createStore(StoreModel store);
  Future<void> addProduct(ProductModel product);
  Future<void> editProduct(ProductModel product);
  Future<void> deleteProduct(int productId);
}

class StoreRepositoryImpl implements StoreRepository {
  final TradlyApiClient _apiClient;

  StoreRepositoryImpl({
    required TradlyApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<bool> hasStore() async {
    String apiUrl = 'stores';
    final response = await _apiClient.get(apiUrl);
    final jsonData = response.data;

    return jsonData.isNotEmpty;
  }

  @override
  Future<void> createStore(StoreModel store) async {
    final supabase = Supabase.instance.client;

    await supabase.from('stores').insert(
      {
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
      },
    ).select();
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    final supabase = Supabase.instance.client;
    await supabase.from('products').insert(
      {
        'title': product.title,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'brand': product.brand,
        'storeId': product.storeId,
      },
    ).select();
  }

  @override
  Future<void> editProduct(ProductModel product) async {
    final supabase = Supabase.instance.client;
    await supabase.from('products').update(
      {
        'title': product.title,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'brand': product.brand,
        'storeId': product.storeId,
      },
    ).eq('id', product.id ?? 0);
  }

  @override
  Future<void> deleteProduct(int productId) async {
    final supabase = Supabase.instance.client;
    await supabase.from('products').delete().eq('id', productId);
  }
}
