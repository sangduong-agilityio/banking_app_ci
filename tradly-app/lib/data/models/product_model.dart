enum ProductTag {
  newProduct,
  mostPopular,
}

class ProductType {
  final int id;
  final int productId;
  final String type;

  ProductType({
    required this.id,
    required this.productId,
    required this.type,
  });

  // Factory method to create a ProductType from a JSON object
  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json['id'],
      productId: json['product_id'],
      type: json['type'],
    );
  }

  // Method to convert ProductType to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'type': type,
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
  final int? categoryId;
  final List<ProductType>? productTypes;

  ProductModel({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.brand,
    this.newPrice,
    this.categoryId,
    this.productTypes,
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
      categoryId: json['categoryId'],
      productTypes: (json['product_types'] as List<dynamic>?)
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
      'newPrice': newPrice,
      'categoryId': categoryId,
      'product_types': productTypes?.map((e) => e.toJson()).toList(),
    };
  }
}
