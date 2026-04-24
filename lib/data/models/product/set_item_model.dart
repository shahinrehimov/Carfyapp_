class SetItemModel {
  final int id;
  final String slug;
  final String title;
  final double price;
  final double priceFinal;
  final int stock;

  SetItemModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.price,
    required this.priceFinal,
    required this.stock,
  });

  factory SetItemModel.fromJson(Map<String, dynamic> json) {
    return SetItemModel(
      id: json['id'] as int,
      slug: json['slug'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      priceFinal: (json['price_final'] as num).toDouble(),
      stock: json['stock'] as int,
    );
  }
}
