class CarLibraryItemModel {
  final int id;
  final String title;

  CarLibraryItemModel({required this.id, required this.title});

  factory CarLibraryItemModel.fromJson(Map<String, dynamic> json) {
    return CarLibraryItemModel(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}
