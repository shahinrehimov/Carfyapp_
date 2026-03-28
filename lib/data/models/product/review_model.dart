class ReviewModel {
  final int id;
  final int rating;
  final String name;
  final String surname;
  final String review;
  final String date;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.name,
    required this.surname,
    required this.review,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as int,
      rating: json['rating'] as int,
      name: json['name'] as String,
      surname: json['surname'] as String,
      review: json['review'] as String,
      date: json['date'] as String,
    );
  }
}
