class EngineVolumeModel {
  final int id;
  final String title;
  final String valueLiters;
  final int valueCc;

  EngineVolumeModel({
    required this.id,
    required this.title,
    required this.valueLiters,
    required this.valueCc,
  });

  factory EngineVolumeModel.fromJson(Map<String, dynamic> json) {
    return EngineVolumeModel(
      id: json['id'] as int,
      title: json['title'] as String,
      valueLiters: json['value_liters'] as String,
      valueCc: json['value_cc'] as int,
    );
  }
}
