class FitmentSelectionOptionsModel {
  final bool anyBrand;
  final List<FitmentBrandOptionModel> brands;

  FitmentSelectionOptionsModel({required this.anyBrand, required this.brands});

  factory FitmentSelectionOptionsModel.fromJson(Map<String, dynamic> json) {
    return FitmentSelectionOptionsModel(
      anyBrand: json['any_brand'] as bool? ?? false,
      brands: (json['brands'] as List<dynamic>? ?? [])
          .map((e) => FitmentBrandOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FitmentBrandOptionModel {
  final int id;
  final String title;
  final bool anyModel;
  final List<FitmentModelOptionModel> models;

  FitmentBrandOptionModel({
    required this.id,
    required this.title,
    required this.anyModel,
    required this.models,
  });

  factory FitmentBrandOptionModel.fromJson(Map<String, dynamic> json) {
    return FitmentBrandOptionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      anyModel: json['any_model'] as bool? ?? false,
      models: (json['models'] as List<dynamic>? ?? [])
          .map((e) => FitmentModelOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FitmentModelOptionModel {
  final int id;
  final String title;

  FitmentModelOptionModel({required this.id, required this.title});

  factory FitmentModelOptionModel.fromJson(Map<String, dynamic> json) {
    return FitmentModelOptionModel(id: json['id'] as int, title: json['title'] as String);
  }
}
