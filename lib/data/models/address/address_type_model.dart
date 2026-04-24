class AddressTypeModel {
  final int id;
  final String title;

  AddressTypeModel({required this.id, required this.title});

  factory AddressTypeModel.fromJson(Map<String, dynamic> json) => AddressTypeModel(
        id: json['id'] as int,
        title: json['title'] as String,
      );
}
