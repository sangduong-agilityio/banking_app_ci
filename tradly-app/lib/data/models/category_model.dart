import 'dart:convert';

import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    required this.id,
    required this.category,
    required this.imageUrl,
  });
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String?,
      category: map['category'] as String?,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String? id;
  final String? category;
  final String? imageUrl;

  CategoryModel copyWith({
    String? id,
    String? category,
    String? imageUrl,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [id, category, imageUrl];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'imageUrl': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;
}
