class BrandModelItemModel {
  final int id;
  final String title;

  BrandModelItemModel({
    required this.id,
    required this.title,
  });

  factory BrandModelItemModel.fromJson(Map<String, dynamic> json) {
    return BrandModelItemModel(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}
