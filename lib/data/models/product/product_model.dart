import 'package:carfy/data/models/product/product_detail_model.dart';

class ProductModel {
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
  final String? discountType;
  final String? discountTypeTitle;
  final double discount;
  final bool inWishlist;
  final bool inBasket;
  final String? sellerUuid;
  final ProductDetailModel product;

  ProductModel({
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
    this.sellerUuid,
    required this.product,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      hoverImage: json['hover_image'] as String?,
      isSet: json['is_set'] as bool,
      stock: json['stock'] as int,
      price: (json['price'] as num).toDouble(),
      priceFinal: (json['price_final'] as num).toDouble(),
      hasDiscount: json['has_discount'] as bool,
      discountType: json['discount_type'] as String?,
      discountTypeTitle: json['discount_type_title'] as String?,
      discount: (json['discount'] as num).toDouble(),
      inWishlist: json['in_wishlist'] as bool,
      inBasket: json['in_basket'] as bool,
      sellerUuid: (json['seller'] as Map<String, dynamic>?)?['uuid'] as String?,
      product: ProductDetailModel.fromJson(json['product'] as Map<String, dynamic>),
    );
  }
}
