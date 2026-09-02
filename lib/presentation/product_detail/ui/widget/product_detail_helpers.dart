import 'package:carfy/domain/entities/products/product_show.dart';

List<String> getAllImages(ProductShow product) {
  final seen = <String>{};
  final images = <String>[];
  void add(String? url) {
    if (url == null || url.isEmpty) return;
    if (seen.add(url)) images.add(url);
  }

  // Variant images
  add(product.mainImage);
  add(product.hoverImage);
  for (final url in product.images) {
    add(url);
  }

  // Main product images
  add(product.product?.mainImage);
  add(product.product?.hoverImage);
  for (final url in product.product?.images ?? []) {
    add(url);
  }

  // Gallery images
  for (final img in product.gallery) {
    add(img.url);
  }

  return images;
}
