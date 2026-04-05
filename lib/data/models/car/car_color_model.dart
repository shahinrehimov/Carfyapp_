class CarColorModel {
  final int id;
  final String title;
  final String hexCode;

  CarColorModel({
    required this.id,
    required this.title,
    required this.hexCode,
  });

  factory CarColorModel.fromJson(Map<String, dynamic> json) {
    return CarColorModel(
      id: json['id'] as int,
      title: json['title'] as String,
      hexCode: json['hex_code'] as String,
    );
  }
}
