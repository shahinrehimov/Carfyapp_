class FilterCategory {
  final int id;
  final String slug;
  final String title;
  final List<FilterCategory> children;

  FilterCategory({
    required this.id,
    required this.slug,
    required this.title,
    this.children = const [],
  });
}
