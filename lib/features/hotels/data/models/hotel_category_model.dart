class HotelCategoryModel {
  final String id;
  final String category;

  HotelCategoryModel({required this.id, required this.category});

  factory HotelCategoryModel.fromJson(Map<String, dynamic> json) {
    return HotelCategoryModel(
      id: json['id'],
      category: json['category'] ?? '',
    );
  }
}
