class FitmentSelectionModel {
  final FitmentPartyModel? brand;
  final FitmentPartyModel? brandModel;

  FitmentSelectionModel({this.brand, this.brandModel});

  factory FitmentSelectionModel.fromJson(Map<String, dynamic> json) {
    return FitmentSelectionModel(
      brand: json['brand'] != null ? FitmentPartyModel.fromJson(json['brand'] as Map<String, dynamic>) : null,
      brandModel: json['brand_model'] != null
          ? FitmentPartyModel.fromJson(json['brand_model'] as Map<String, dynamic>)
          : null,
    );
  }
}

class FitmentPartyModel {
  final int id;
  final String title;

  FitmentPartyModel({required this.id, required this.title});

  factory FitmentPartyModel.fromJson(Map<String, dynamic> json) {
    return FitmentPartyModel(id: json['id'] as int, title: json['title'] as String);
  }
}
