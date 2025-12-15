class Category {
  final int id;
  final String uuid;
  final String slug;
  final String title;
  final String image;
  final List<SubCategory> subs;

  Category({
    required this.id,
    required this.uuid,
    required this.slug,
    required this.title,
    required this.image,
    required this.subs,
  });
}

class SubCategory {
  final int id;
  final String uuid;
  final String slug;
  final String title;

  SubCategory({required this.id, required this.uuid, required this.slug, required this.title});
}
