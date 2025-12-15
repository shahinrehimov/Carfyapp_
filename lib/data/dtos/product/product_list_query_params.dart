class ProductListQueryParams {
  final int page;
  final int limit;

  ProductListQueryParams({
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toQueryParameters() => {
        'page': page,
        'limit': limit,
      };
}
