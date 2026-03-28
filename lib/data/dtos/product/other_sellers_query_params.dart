class OtherSellersQueryParams {
  final int page;
  final int limit;

  OtherSellersQueryParams({
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'limit': limit,
    };
  }
}
