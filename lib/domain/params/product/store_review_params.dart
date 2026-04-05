class StoreReviewParams {
  final String cpvUuid;
  final int rating;
  final String name;
  final String surname;
  final String email;
  final String review;
  final List<String> imagePaths;

  StoreReviewParams({
    required this.cpvUuid,
    required this.rating,
    required this.name,
    required this.surname,
    required this.email,
    required this.review,
    this.imagePaths = const [],
  });
}
