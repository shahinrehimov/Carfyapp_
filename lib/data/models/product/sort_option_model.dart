class SortOptionModel {
  final String id;
  final String title;

  SortOptionModel({required this.id, required this.title});

  factory SortOptionModel.fromJson(Map<String, dynamic> json) {
    return SortOptionModel(id: json['id'].toString(), title: json['title'] as String);
  }
}
