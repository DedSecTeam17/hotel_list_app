class FilterCategoryModel {
  final String id;
  final String name;

  FilterCategoryModel({required this.id, required this.name});

  factory FilterCategoryModel.fromJson(Map<String, dynamic> json) {
    return FilterCategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class FilterGroupModel {
  final String name;
  final List<FilterCategoryModel> categories;

  FilterGroupModel({
    required this.name,
    required this.categories,
  });

  factory FilterGroupModel.fromJson(Map<String, dynamic> json) {
    return FilterGroupModel(
      name: json['name'],
      categories: (json['categories'] as List)
          .map((e) => FilterCategoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }
}
