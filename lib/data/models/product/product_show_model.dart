import 'package:carfy/data/models/product/brand_model_item_model.dart';
import 'package:carfy/data/models/product/fitment_model.dart';
import 'package:carfy/data/models/product/gallery_image_model.dart';
import 'package:carfy/data/models/product/other_seller_model.dart';
import 'package:carfy/data/models/product/product_detail_model.dart';
import 'package:carfy/data/models/product/product_model.dart';
import 'package:carfy/data/models/product/product_option_model.dart';
import 'package:carfy/data/models/product/product_ratings_model.dart';
import 'package:carfy/data/models/product/seller_model.dart';
import 'package:carfy/data/models/product/set_item_model.dart';

class ProductShowModel {
  final int id;
  final String uuid;
  final String? oemCode;
  final String title;
  final String? mainImage;
  final String? hoverImage;
  final List<String> images;
  final bool isSet;
  final List<SetItemModel> sets;
  final int stock;
  final double price;
  final double priceFinal;
  final bool hasDiscount;
  final String? discountType;
  final String? discountTypeTitle;
  final double discount;
  final bool isUniversal;
  final int? year;
  final int? yearFrom;
  final int? yearTo;
  final List<FitmentModel> fitments;
  final bool inWishlist;
  final bool inBasket;
  final List<BrandModelItemModel> brandModels;
  final List<ProductOptionModel> options;
  final ProductRatingsModel? ratings;
  final SellerModel? seller;
  final int sellersCount;
  final List<GalleryImageModel> gallery;
  final List<OtherSellerModel> otherSellers;
  final int otherSellersTotal;
  final List<ProductModel> relatedProducts;
  final ProductDetailModel? product;

  ProductShowModel({
    required this.id,
    required this.uuid,
    this.oemCode,
    required this.title,
    this.mainImage,
    this.hoverImage,
    this.images = const [],
    required this.isSet,
    this.sets = const [],
    required this.stock,
    required this.price,
    required this.priceFinal,
    required this.hasDiscount,
    this.discountType,
    this.discountTypeTitle,
    required this.discount,
    required this.isUniversal,
    this.year,
    this.yearFrom,
    this.yearTo,
    this.fitments = const [],
    required this.inWishlist,
    required this.inBasket,
    this.brandModels = const [],
    this.options = const [],
    this.ratings,
    this.seller,
    required this.sellersCount,
    this.gallery = const [],
    this.otherSellers = const [],
    required this.otherSellersTotal,
    this.relatedProducts = const [],
    this.product,
  });

  factory ProductShowModel.fromJson(Map<String, dynamic> json) {
    return ProductShowModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      oemCode: json['oem_code'] as String?,
      title: json['title'] as String,
      mainImage: json['main_image'] as String?,
      hoverImage: json['hover_image'] as String?,
      images: json['images'] != null ? (json['images'] as List<dynamic>).map((e) => e as String).toList() : [],
      isSet: json['is_set'] as bool? ?? false,
      sets: json['sets'] != null
          ? (json['sets'] as List<dynamic>).map((e) => SetItemModel.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      stock: json['stock'] as int,
      price: (json['price'] as num).toDouble(),
      priceFinal: (json['price_final'] as num).toDouble(),
      hasDiscount: json['has_discount'] as bool,
      discountType: json['discount_type'] as String?,
      discountTypeTitle: json['discount_type_title'] as String?,
      discount: (json['discount'] as num).toDouble(),
      isUniversal: json['is_universal'] as bool? ?? false,
      year: json['year'] as int?,
      yearFrom: json['year_from'] as int?,
      yearTo: json['year_to'] as int?,
      fitments: json['fitments'] != null
          ? (json['fitments'] as List<dynamic>).map((e) => FitmentModel.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      inWishlist: json['in_wishlist'] as bool,
      inBasket: json['in_basket'] as bool,
      brandModels: json['brand_models'] != null
          ? (json['brand_models'] as List<dynamic>)
                .map((e) => BrandModelItemModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      options: json['options'] != null
          ? (json['options'] as List<dynamic>)
                .map((e) => ProductOptionModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      ratings: json['ratings'] != null ? ProductRatingsModel.fromJson(json['ratings'] as Map<String, dynamic>) : null,
      seller: json['seller'] != null ? SellerModel.fromJson(json['seller'] as Map<String, dynamic>) : null,
      sellersCount: json['sellers_count'] as int? ?? 0,
      gallery: json['seller'] != null && json['seller']['gallery'] != null
          ? (json['seller']['gallery'] as List<dynamic>)
                .map((e) => GalleryImageModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      otherSellers: json['other_sellers'] != null
          ? (json['other_sellers'] as List<dynamic>)
                .map((e) => OtherSellerModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      otherSellersTotal: json['other_sellers_total'] as int? ?? 0,
      relatedProducts: json['related_products'] != null
          ? (json['related_products'] as List<dynamic>)
                .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      product: json['product'] != null ? ProductDetailModel.fromJson(json['product'] as Map<String, dynamic>) : null,
    );
  }
}
