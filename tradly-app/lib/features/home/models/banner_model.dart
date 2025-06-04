class BannerModel {
  final int? id;
  final String? title;
  final String? imageUrl;
  final String? buttonText;

  BannerModel({
    this.id,
    this.title,
    this.imageUrl,
    this.buttonText,
  });
  // Factory method to create a BannerModel from a JSON object
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      buttonText: json['buttonText'],
    );
  }
  // Method to convert BannerModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'buttonText': buttonText,
    };
  }
}
