class OrdersLoadQueryParams {
  final int page;
  final int limit;

  OrdersLoadQueryParams({required this.page, required this.limit});

  Map<String, dynamic> toQueryParameters() {
    return {'page': page, 'limit': limit};
  }
}
