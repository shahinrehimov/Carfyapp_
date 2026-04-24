class CityModel {
  final int id;
  final String title;

  CityModel({
    required this.id,
    required this.title,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}
