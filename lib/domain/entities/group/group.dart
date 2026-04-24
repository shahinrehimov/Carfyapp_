import 'package:carfy/domain/entities/products/product.dart';

class Group {
  final String name;
  final String slug;
  final String title;
  final String? description;
  final String? image;
  final List<Product> products;

  Group({
    required this.name,
    required this.slug,
    required this.title,
    this.description,
    this.image,
    required this.products,
  });
}
