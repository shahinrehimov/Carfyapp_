class NotificationsLoadQueryParams {
  final int page;
  final int limit;

  NotificationsLoadQueryParams({required this.page, required this.limit});

  Map<String, dynamic> toQueryParameters() => {
        'page': page,
        'limit': limit,
      };
}
