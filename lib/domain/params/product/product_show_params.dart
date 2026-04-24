class ProductShowParams {
  final String? parentSlug;
  final String subSlug;
  final String productSlug;
  final String? variant;
  final String? seller;
  final bool otherSellers;
  final bool withRelated;

  ProductShowParams({
    this.parentSlug,
    required this.subSlug,
    required this.productSlug,
    this.variant,
    this.seller,
    this.otherSellers = false,
    this.withRelated = false,
  });
}
