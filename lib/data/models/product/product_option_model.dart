class ProductOptionModel {
  final OptionInfoModel option;
  final OptionItemModel item;

  ProductOptionModel({
    required this.option,
    required this.item,
  });

  factory ProductOptionModel.fromJson(Map<String, dynamic> json) {
    return ProductOptionModel(
      option: OptionInfoModel.fromJson(json['option'] as Map<String, dynamic>),
      item: OptionItemModel.fromJson(json['item'] as Map<String, dynamic>),
    );
  }
}

class OptionInfoModel {
  final int id;
  final String title;

  OptionInfoModel({
    required this.id,
    required this.title,
  });

  factory OptionInfoModel.fromJson(Map<String, dynamic> json) {
    return OptionInfoModel(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}

class OptionItemModel {
  final int id;
  final String title;

  OptionItemModel({
    required this.id,
    required this.title,
  });

  factory OptionItemModel.fromJson(Map<String, dynamic> json) {
    return OptionItemModel(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}
