class StoreReviewDto {
  final int rating;
  final String name;
  final String surname;
  final String email;
  final String review;
  final List<String> imagePaths;

  StoreReviewDto({
    required this.rating,
    required this.name,
    required this.surname,
    required this.email,
    required this.review,
    this.imagePaths = const [],
  });
}
