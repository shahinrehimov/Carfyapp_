import 'package:carfy/domain/entities/products/product_show.dart';

List<String> getAllImages(ProductShow product) => product.gallery.map((e)=>e.url).toList();
