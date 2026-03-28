class LoadReviewsQueryParams {
  final int page;
  final int limit;

  LoadReviewsQueryParams({
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
