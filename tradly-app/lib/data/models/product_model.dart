enum ProductTag {
  newProduct,
  mostPopular,
}

class ProductModel {
  final String? id;
  final String title;
  final String imageUrl;
  final String price;
  final String? brand;
  final String? newPrice;
  final int? inCategory;

  ProductModel({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.brand,
    this.newPrice,
    this.inCategory,
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
      inCategory: json['inCategory'],
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
      'inCategory': inCategory,
    };
  }
}
