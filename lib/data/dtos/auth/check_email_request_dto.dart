class CheckEmailRequestDto {
  final String email;

  CheckEmailRequestDto({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}
