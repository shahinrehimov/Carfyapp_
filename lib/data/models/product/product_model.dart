import 'package:carfy/data/models/product/product_info_model.dart';
import 'package:carfy/data/models/product/product_ratings_model.dart';
import 'package:carfy/data/models/product/seller_model.dart';

class ProductModel {
  final int? id;
  final String uuid;
  final String? oemCode;
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
  final SellerModel? seller;
  final ProductInfoModel product;
  final ProductRatingsModel? ratings;

  ProductModel({
    this.id,
    required this.uuid,
    this.oemCode,
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
    this.seller,
    required this.product,
    this.ratings,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      uuid: json['uuid'] as String,
      oemCode: json['oem_code'] as String?,
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
      seller: json['seller'] != null ? SellerModel.fromJson(json['seller'] as Map<String, dynamic>) : null,
      product: ProductInfoModel.fromJson(json['product'] as Map<String, dynamic>),
      ratings: json['ratings'] != null ? ProductRatingsModel.fromJson(json['ratings'] as Map<String, dynamic>) : null,
    );
  }
}
