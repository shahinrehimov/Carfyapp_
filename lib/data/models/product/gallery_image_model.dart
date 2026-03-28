class GalleryImageModel {
  final String source;
  final String url;

  GalleryImageModel({
    required this.source,
    required this.url,
  });

  factory GalleryImageModel.fromJson(Map<String, dynamic> json) {
    return GalleryImageModel(
      source: json['source'] as String,
      url: json['url'] as String,
    );
  }
}
