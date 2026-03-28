class StoreReviewDto {
  final int rating;
  final String name;
  final String surname;
  final String email;
  final String review;

  StoreReviewDto({
    required this.rating,
    required this.name,
    required this.surname,
    required this.email,
    required this.review,
  });

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'name': name,
        'surname': surname,
        'email': email,
        'review': review,
      };
}
