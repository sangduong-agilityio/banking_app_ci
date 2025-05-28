enum ProductTag {
  newProduct,
  mostPopular,
}

class ProductType {
  final int id;
  final int productId;
  final String tag;

  ProductType({
    required this.id,
    required this.productId,
    required this.tag,
  });

  // Factory method to create a ProductType from a JSON object
  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json['id'],
      productId: json['productId'],
      tag: json['tag'],
    );
  }

  // Method to convert ProductType to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'tag': tag,
    };
  }
}

class ProductModel {
  final int? id;
  final String title;
  final String imageUrl;
  final String price;
  final String? brand;
  final String? newPrice;
  final String? description;
  final String? priceType;
  final String? condition;
  final String? location;
  final String? street;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? categoryType;
  final int? categoryId;
  final int? storeId;
  final List<ProductType>? productType;

  ProductModel({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.brand,
    this.newPrice,
    this.categoryId,
    this.description,
    this.priceType,
    this.condition,
    this.street,
    this.city,
    this.location,
    this.state,
    this.zipCode,
    this.categoryType,
    this.storeId,
    this.productType,
  });

  // Factory method to create a ProductModel from a JSON object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      brand: json['brand'],
      newPrice: json['newPrice'],
      description: json['description'],
      priceType: json['priceType'],
      condition: json['condition'],
      location: json['location'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      categoryType: json['categoryType'],
      categoryId: json['categoryId'],
      storeId: json['storeId'],
      productType: (json['productType'] as List<dynamic>?)
          ?.map((e) => ProductType.fromJson(e))
          .toList(),
    );
  }

  // Method to convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'brand': brand,
      'description': description,
      'newPrice': newPrice,
      'priceType': priceType,
      'condition': condition,
      'location': location,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'categoryType': categoryType,
      'categoryId': categoryId,
      'storeId': storeId,
      'productType': productType?.map((e) => e.toJson()).toList(),
    };
  }

  ProductModel copyWith({
    int? id,
    String? title,
    String? imageUrl,
    String? price,
    String? brand,
    String? newPrice,
    String? description,
    String? priceType,
    String? condition,
    String? location,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? categoryType,
    int? categoryId,
    int? storeId,
    List<ProductType>? productType,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      brand: brand ?? this.brand,
      newPrice: newPrice ?? this.newPrice,
      description: description ?? this.description,
      priceType: priceType ?? this.priceType,
      location: location ?? this.location,
      condition: condition ?? this.condition,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      categoryType: categoryType ?? this.categoryType,
      categoryId: categoryId ?? this.categoryId,
      storeId: storeId ?? this.storeId,
      productType: productType ?? this.productType,
    );
  }
}
