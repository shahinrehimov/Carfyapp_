class BrandModel {
  final int id;
  final String uuid;
  final String slug;
  final String title;

  BrandModel({
    required this.id,
    required this.uuid,
    required this.slug,
    required this.title,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
    );
  }
}
