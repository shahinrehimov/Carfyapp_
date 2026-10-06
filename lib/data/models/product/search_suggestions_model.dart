class SearchSuggestionsModel {
  final List<SuggestionProductModel> products;
  final List<SuggestionCategoryModel> categories;

  SearchSuggestionsModel({required this.products, required this.categories});

  factory SearchSuggestionsModel.fromJson(Map<String, dynamic> json) {
    return SearchSuggestionsModel(
      products: (json['products'] as List<dynamic>)
          .map((e) => SuggestionProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => SuggestionCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SuggestionProductModel {
  final int id;
  final String uuid;
  final String title;
  final String? oemCode;
  final String? image;
  final double price;
  final double priceFinal;
  final bool hasDiscount;
  final String? discountType;
  final double? discount;
  final SuggestionProductCategoryModel? category;
  final SuggestionSellerModel seller;
  final SuggestionSellersModel sellers;

  SuggestionProductModel({
    required this.id,
    required this.uuid,
    required this.title,
    this.oemCode,
    this.image,
    required this.price,
    required this.priceFinal,
    required this.hasDiscount,
    this.discountType,
    this.discount,
    this.category,
    required this.seller,
    required this.sellers,
  });

  factory SuggestionProductModel.fromJson(Map<String, dynamic> json) {
    return SuggestionProductModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      oemCode: json['oem_code'] as String?,
      image: json['image'] as String?,
      price: (json['price'] as num).toDouble(),
      priceFinal: (json['price_final'] as num).toDouble(),
      hasDiscount: json['has_discount'] as bool,
      discountType: json['discount_type'] as String?,
      discount: json['discount'] != null ? (json['discount'] as num).toDouble() : null,
      category: json['category'] != null
          ? SuggestionProductCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      seller: SuggestionSellerModel.fromJson(json['seller'] as Map<String, dynamic>),
      sellers: SuggestionSellersModel.fromJson(json['sellers'] as Map<String, dynamic>),
    );
  }
}

class SuggestionProductCategoryModel {
  final String? title;
  final String? slug;
  final String? parentTitle;
  final String? parentSlug;

  SuggestionProductCategoryModel({this.title, this.slug, this.parentTitle, this.parentSlug});

  factory SuggestionProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return SuggestionProductCategoryModel(
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      parentTitle: json['parent_title'] as String?,
      parentSlug: json['parent_slug'] as String?,
    );
  }
}

class SuggestionSellerModel {
  final String? storeCode;
  final String? label;

  SuggestionSellerModel({this.storeCode, this.label});

  factory SuggestionSellerModel.fromJson(Map<String, dynamic> json) {
    return SuggestionSellerModel(
      storeCode: json['store_code'] as String?,
      label: json['label'] as String?,
    );
  }
}

class SuggestionSellersModel {
  final int count;
  final double minPrice;
  final double maxPrice;
  final bool hasOtherPrices;

  SuggestionSellersModel({
    required this.count,
    required this.minPrice,
    required this.maxPrice,
    required this.hasOtherPrices,
  });

  factory SuggestionSellersModel.fromJson(Map<String, dynamic> json) {
    return SuggestionSellersModel(
      count: json['count'] as int,
      minPrice: (json['min_price'] as num).toDouble(),
      maxPrice: (json['max_price'] as num).toDouble(),
      hasOtherPrices: json['has_other_prices'] as bool,
    );
  }
}

class SuggestionCategoryModel {
  final int id;
  final String title;
  final String slug;
  final bool isSub;
  final SuggestionCategoryParentModel? parent;
  final int productsCount;

  SuggestionCategoryModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.isSub,
    this.parent,
    required this.productsCount,
  });

  factory SuggestionCategoryModel.fromJson(Map<String, dynamic> json) {
    return SuggestionCategoryModel(
      id: json['id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String,
      isSub: json['is_sub'] as bool,
      parent: json['parent'] != null
          ? SuggestionCategoryParentModel.fromJson(json['parent'] as Map<String, dynamic>)
          : null,
      productsCount: json['products_count'] as int,
    );
  }
}

class SuggestionCategoryParentModel {
  final String title;
  final String slug;

  SuggestionCategoryParentModel({required this.title, required this.slug});

  factory SuggestionCategoryParentModel.fromJson(Map<String, dynamic> json) {
    return SuggestionCategoryParentModel(
      title: json['title'] as String,
      slug: json['slug'] as String,
    );
  }
}
