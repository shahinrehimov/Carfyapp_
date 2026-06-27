class FilterOptionModel {
  final String slug;
  final String title;

  FilterOptionModel({required this.slug, required this.title});

  factory FilterOptionModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionModel(slug: json['slug'] as String, title: json['title'] as String);
  }
}
