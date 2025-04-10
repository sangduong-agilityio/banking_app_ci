class StoreModel {
  final String id;
  final String store;
  final String imageUrl;
  final String logoStore;
  final String? isFollowed;
  final String? userId;

  StoreModel({
    required this.id,
    required this.store,
    required this.imageUrl,
    required this.logoStore,
    this.isFollowed,
    this.userId,
  });

  // Factory method to create a StoreModel from a JSON object
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      store: json['store'],
      imageUrl: json['imageUrl'],
      logoStore: json['logoStore'],
      isFollowed: json['isFollowed'],
      userId: json['userId'],
    );
  }

  // Method to convert StoreModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store': store,
      'imageUrl': imageUrl,
      'logoStore': logoStore,
      'isFollowed': isFollowed,
      'userId': userId,
    };
  }
}
