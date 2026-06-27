class ProductRatingsModel {
  final double average;
  final int count;
  final List<RatingEntryModel> list;

  ProductRatingsModel({required this.average, required this.count, this.list = const []});

  factory ProductRatingsModel.fromJson(Map<String, dynamic> json) {
    return ProductRatingsModel(
      average: (json['average'] as num).toDouble(),
      count: json['count'] as int,
      list: json['list'] != null
          ? (json['list'] as List<dynamic>).map((e) => RatingEntryModel.fromJson(e as Map<String, dynamic>)).toList()
          : [],
    );
  }
}

class RatingEntryModel {
  final int rating;
  final int count;

  RatingEntryModel({required this.rating, required this.count});

  factory RatingEntryModel.fromJson(Map<String, dynamic> json) {
    return RatingEntryModel(rating: json['rating'] as int, count: json['count'] as int);
  }
}
