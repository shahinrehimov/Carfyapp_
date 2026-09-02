import 'package:carfy/domain/entities/products/brand_model_item.dart';
import 'package:carfy/domain/entities/products/fitment.dart';
import 'package:carfy/domain/entities/products/gallery_image.dart';
import 'package:carfy/domain/entities/products/other_seller.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/entities/products/product_detail.dart';
import 'package:carfy/domain/entities/products/product_option.dart';
import 'package:carfy/domain/entities/products/product_ratings.dart';
import 'package:carfy/domain/entities/products/seller.dart';
import 'package:carfy/domain/entities/products/set_item.dart';
import 'package:carfy/domain/enums/discount_type.dart';

class ProductShow {
  final int id;
  final String uuid;
  final String? oemCode;
  final String title;
  final String? mainImage;
  final String? hoverImage;
  final List<String> images;
  final bool isSet;
  final List<SetItem> sets;
  final int stock;
  final double price;
  final double priceFinal;
  final bool hasDiscount;
  final DiscountType? discountType;
  final String? discountTypeTitle;
  final double discount;
  final bool isUniversal;
  final int? year;
  final int? yearFrom;
  final int? yearTo;
  final List<Fitment> fitments;
  final bool inWishlist;
  final bool inBasket;
  final List<BrandModelItem> brandModels;
  final List<ProductOption> options;
  final ProductRatings? ratings;
  final Seller? seller;
  final int sellersCount;
  final List<GalleryImage> gallery;
  final List<OtherSeller> otherSellers;
  final int otherSellersTotal;
  final List<Product> relatedProducts;
  final ProductDetail? product;

  ProductShow({
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
}
