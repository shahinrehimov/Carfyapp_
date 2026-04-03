class ProductCategory {
  final int id;
  final String uuid;
  final String slug;
  final String title;
  final ProductCategory? parent;

  ProductCategory({
    required this.id,
    required this.uuid,
    required this.slug,
    required this.title,
    this.parent,
  });
}
