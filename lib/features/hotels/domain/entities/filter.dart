class FilterCategory {
  final String id;
  final String name;

  FilterCategory({required this.id, required this.name});
}

class FilterGroup {
  final String name;
  final List<FilterCategory> categories;

  FilterGroup({
    required this.name,
    required this.categories,
  });
}
