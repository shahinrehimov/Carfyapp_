class FilterCategoryModel {
  final int id;
  final String slug;
  final String title;
  final List<FilterCategoryModel> children;

  FilterCategoryModel({required this.id, required this.slug, required this.title, this.children = const []});

  factory FilterCategoryModel.fromJson(Map<String, dynamic> json) {
    return FilterCategoryModel(
      id: json['id'] as int,
      slug: json['slug'] as String,
      title: json['title'] as String,
      children: json['subs'] != null ? (json['subs'] as List).map((e) => FilterCategoryModel.fromJson(e)).toList() : [],
    );
  }
}
