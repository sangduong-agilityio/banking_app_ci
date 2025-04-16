class StoreModel {
  final int id;
  final String name;
  final String imageUrl;
  final String logoStore;
  final String? isFollowed;
  final int? userId;

  StoreModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.logoStore,
    this.isFollowed,
    this.userId,
  });

  // Factory method to create a StoreModel from a JSON object
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
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
      'name': name,
      'imageUrl': imageUrl,
      'logoStore': logoStore,
      'isFollowed': isFollowed,
      'userId': userId,
    };
  }
}
