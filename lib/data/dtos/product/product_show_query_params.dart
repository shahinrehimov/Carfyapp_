class ProductShowQueryParams {
  final String? variant;
  final String? seller;
  final bool otherSellers;
  final bool withRelated;

  ProductShowQueryParams({
    this.variant,
    this.seller,
    this.otherSellers = false,
    this.withRelated = false,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    if (variant != null) params['variant'] = variant;
    if (seller != null) params['seller'] = seller;
    if (otherSellers) params['other_sellers'] = 'yes';
    if (withRelated) params['with_related'] = 'yes';
    return params;
  }
}
