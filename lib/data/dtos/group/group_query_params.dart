class GroupQueryParams {
  final String slug;
  final int? limit;

  GroupQueryParams({
    required this.slug,
    this.limit,
  });

  Map<String, dynamic> toQueryParameters() => {
        if (limit != null) 'limit': limit,
      };
}
