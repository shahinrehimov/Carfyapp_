import 'package:carfy/domain/entities/products/product_detail.dart';
import 'package:carfy/domain/enums/discount_type.dart';

class Product {
  final int id;
  final String uuid;
  final String slug;
  final String title;
  final String? hoverImage;
  final bool isSet;
  final int stock;
  final double price;
  final double priceFinal;
  final bool hasDiscount;
  final DiscountType? discountType;
  final String? discountTypeTitle;
  final double discount;
  final bool inWishlist;
  final bool inBasket;
  final ProductDetail product;

  Product({
    required this.id,
    required this.uuid,
    required this.slug,
    required this.title,
    this.hoverImage,
    required this.isSet,
    required this.stock,
    required this.price,
    required this.priceFinal,
    required this.hasDiscount,
    required this.discountType,
    required this.discountTypeTitle,
    required this.discount,
    required this.inWishlist,
    required this.inBasket,
    required this.product,
  });
}
