class PaginationResponseModel<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  PaginationResponseModel({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  factory PaginationResponseModel.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    final meta = json['meta'] as Map<String, dynamic>;
    return PaginationResponseModel(
      data: (json['data'] as List<dynamic>).map((item) => fromJsonT(item as Map<String, dynamic>)).toList(),
      currentPage: meta['current_page'] as int,
      lastPage: meta['last_page'] as int,
      total: meta['total'] as int,
      perPage: meta['per_page'] as int,
    );
  }

  factory PaginationResponseModel.fromFlatJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PaginationResponseModel(
      data: (json['data'] as List<dynamic>).map((item) => fromJsonT(item as Map<String, dynamic>)).toList(),
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      total: json['total'] as int,
      perPage: json['per_page'] as int,
    );
  }

  bool get hasNextPage => currentPage < lastPage;

  bool get hasPreviousPage => currentPage > 1;
}
