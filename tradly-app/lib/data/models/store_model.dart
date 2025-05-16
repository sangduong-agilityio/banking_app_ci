import 'package:tradly_app/data/models/product_model.dart';

class StoreModel {
  final int? id;
  final String storeName;
  final String? storeWebAddress;
  final String? storeDescription;
  final String? storeType;
  final String? imageUrl;
  final String? address;
  final String? city;
  final String? logoStore;
  final String? country;
  final String? courieName;
  final List<ProductModel>? products;

  StoreModel({
    this.id,
    required this.storeName,
    this.imageUrl,
    this.logoStore,
    this.storeDescription,
    this.address,
    this.storeWebAddress,
    this.products,
    this.storeType,
    this.city,
    this.country,
    this.courieName,
  });

  // Factory method to create a StoreModel from a JSON object
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List? ?? [];
    List<ProductModel> productModels =
        productList.map((i) => ProductModel.fromJson(i)).toList();
    return StoreModel(
      id: json['id'],
      storeName: json['storeName'],
      imageUrl: json['imageUrl'],
      logoStore: json['logoStore'],
      storeDescription: json['storeDescription'],
      address: json['address'],
      storeWebAddress: json['storeWebAddress'],
      storeType: json['storeType'],
      city: json['city'],
      country: json['country'],
      courieName: json['courieName'],
      products: productModels,
    );
  }

  // Method to convert StoreModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeName': storeName,
      'storeWebAddress': storeWebAddress,
      'storeDescription': storeDescription,
      'storeType': storeType,
      'imageUrl': imageUrl,
      'address': address,
      'city': city,
      'logoStore': logoStore,
      'country': country,
      'courieName': courieName,
      'products': products?.map((product) => product.toJson()).toList(),
    };
  }
}
