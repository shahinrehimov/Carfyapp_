class SearchSuggestions {
  final List<SuggestionProduct> products;
  final List<SuggestionCategory> categories;

  SearchSuggestions({required this.products, required this.categories});
}

class SuggestionProduct {
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
  final SuggestionProductCategory? category;
  final String? sellerStoreCode;
  final int sellersCount;
  final double minPrice;
  final double maxPrice;
  final bool hasOtherPrices;

  SuggestionProduct({
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
    this.sellerStoreCode,
    required this.sellersCount,
    required this.minPrice,
    required this.maxPrice,
    required this.hasOtherPrices,
  });
}

class SuggestionProductCategory {
  final String? title;
  final String? slug;
  final String? parentTitle;
  final String? parentSlug;

  SuggestionProductCategory({this.title, this.slug, this.parentTitle, this.parentSlug});

  String get displayTitle {
    if (parentTitle != null && title != null) return '$parentTitle › $title';
    return title ?? '';
  }
}

class SuggestionCategory {
  final int id;
  final String title;
  final String slug;
  final bool isSub;
  final String? parentTitle;
  final String? parentSlug;
  final int productsCount;

  SuggestionCategory({
    required this.id,
    required this.title,
    required this.slug,
    required this.isSub,
    this.parentTitle,
    this.parentSlug,
    required this.productsCount,
  });

  String get displayTitle {
    if (parentTitle != null) return '$parentTitle › $title';
    return title;
  }
}
