class CategorySlugsModel {
  final String? subCategorySlug;
  final String? parentCategorySlug;

  CategorySlugsModel({this.subCategorySlug, this.parentCategorySlug});

  factory CategorySlugsModel.fromJson(Map<String, dynamic> json) {
    return CategorySlugsModel(
      subCategorySlug: json['sub_category_slug'] as String?,
      parentCategorySlug: json['parent_category_slug'] as String?,
    );
  }
}
