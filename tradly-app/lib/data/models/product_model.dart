import 'dart:convert';

import 'package:equatable/equatable.dart';

enum ProductTag {
  newProduct,
  mostPopular,
}

class ProductModel extends Equatable {
  const ProductModel({
    required this.title,
    required this.imageUrl,
    required this.price,
    this.tags,
    this.newPrice,
    this.inCategory,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String,
      price: map['price'] as String,
      tags: map['tags'] != null ? map['tags'] as String : null,
      newPrice: map['newPrice'] != null ? map['newPrice'] as String : null,
      inCategory:
          map['inCategory'] != null ? map['inCategory'] as String : null,
    );
  }

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String title;
  final String imageUrl;
  final String price;
  final String? tags;
  final String? newPrice;
  final String? inCategory;

  @override
  List<Object?> get props {
    return [
      title,
      imageUrl,
      price,
      tags,
      newPrice,
      inCategory,
    ];
  }

  ProductModel copyWith({
    String? title,
    String? imageUrl,
    String? price,
    String? tags,
    String? newPrice,
    String? inCategory,
  }) {
    return ProductModel(
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      tags: tags ?? this.tags,
      newPrice: newPrice ?? this.newPrice,
      inCategory: inCategory ?? this.inCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'imagePath': imageUrl,
      'price': price,
      'tags': tags,
      'newPrice': newPrice,
      'inCategory': inCategory,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;
}
