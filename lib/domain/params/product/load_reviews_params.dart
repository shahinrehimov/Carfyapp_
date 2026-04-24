class LoadReviewsParams {
  final String cpvUuid;
  final int page;
  final int limit;

  LoadReviewsParams({
    required this.cpvUuid,
    required this.page,
    this.limit = 10,
  });
}
