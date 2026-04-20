class AdvertisementModel {
  final String title;
  final String key;
  final String? imageUrl;
  final String link;

  AdvertisementModel({
    required this.title,
    required this.key,
    required this.imageUrl,
    required this.link,
  });

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      title: json['title'] as String,
      key: json['key'] as String,
      imageUrl: json['image_url'] as String?,
      link: json['link'] as String,
    );
  }
}
