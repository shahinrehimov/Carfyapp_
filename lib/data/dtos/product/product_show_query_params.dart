class ProductShowQueryParams {
  final bool otherSellers;
  final bool withRelated;

  ProductShowQueryParams({
    this.otherSellers = false,
    this.withRelated = false,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    if (otherSellers) params['other_sellers'] = 'yes';
    if (withRelated) params['with_related'] = 'yes';
    return params;
  }
}
