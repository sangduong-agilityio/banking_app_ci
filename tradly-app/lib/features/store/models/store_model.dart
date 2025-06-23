import 'package:tradly_app/features/home/models/product_model.dart';

class StoreModel {
  int? id;
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
  final List<String>? tagLine;
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
    this.tagLine,
  });

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    final productList = map['products'] as List<dynamic>?;

    return StoreModel(
      id: map['id'] as int?,
      storeName: map['storeName'] ?? '',
      imageUrl: map['imageUrl'],
      logoStore: map['logoStore'],
      storeDescription: map['storeDescription'],
      address: map['address'],
      storeWebAddress: map['storeWebAddress'],
      storeType: map['storeType'],
      city: map['city'],
      country: map['country'],
      courieName: map['courieName'],
      tagLine: map['tagLineDetail'] != null
          ? List<String>.from(map['tagLineDetail'])
          : null,
      products:
          productList?.map((item) => ProductModel.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
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
      if (tagLine != null) 'tagLineDetail': tagLine,
      if (products != null)
        'products': products!.map((product) => product.toJson()).toList(),
    };
  }
}
