class ProductRatings {
  final double average;
  final int count;
  final List<RatingEntry> list;

  ProductRatings({
    required this.average,
    required this.count,
    this.list = const [],
  });
}

class RatingEntry {
  final int rating;
  final int count;

  RatingEntry({
    required this.rating,
    required this.count,
  });
}
