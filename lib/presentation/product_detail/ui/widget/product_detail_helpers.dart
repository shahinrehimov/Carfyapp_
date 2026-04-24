import 'package:carfy/domain/entities/products/product_show.dart';

List<String> getAllImages(ProductShow product) {
  final images = <String>[];
  if (product.mainImage != null) images.add(product.mainImage!);
  images.addAll(product.images.where((url) => url != product.mainImage));
  return images;
}
