import 'dart:convert';

import 'package:equatable/equatable.dart';

class StoreModel extends Equatable {
  const StoreModel({
    required this.store,
    required this.imagePath,
    required this.iconPath,
    this.isFollowed,
    this.userId,
  });

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      store: map['store'] as String,
      imagePath: map['imagePath'] as String,
      iconPath: map['iconPath'] as String,
      isFollowed:
          map['isFollowed'] != null ? map['isFollowed'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
    );
  }

  factory StoreModel.fromJson(String source) =>
      StoreModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String store;
  final String imagePath;
  final String iconPath;
  final String? isFollowed;
  final String? userId;

  @override
  List<Object?> get props {
    return [
      store,
      imagePath,
      iconPath,
      isFollowed,
      userId,
    ];
  }

  StoreModel copyWith({
    String? store,
    String? imagePath,
    String? iconPath,
    String? isFollowed,
    String? userId,
  }) {
    return StoreModel(
      store: store ?? this.store,
      imagePath: imagePath ?? this.imagePath,
      iconPath: iconPath ?? this.iconPath,
      isFollowed: isFollowed ?? this.isFollowed,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'store': store,
      'imagePath': imagePath,
      'iconPath': iconPath,
      'isFollowed': isFollowed,
      'userId': userId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;
}
