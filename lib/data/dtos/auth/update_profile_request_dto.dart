class UpdateProfileRequestDto {
  final String name;
  final String surname;
  final String? gender;
  final String? birthDate;

  const UpdateProfileRequestDto({required this.name, required this.surname, this.gender, this.birthDate});

  Map<String, dynamic> toJson() => {
    'name': name,
    'surname': surname,
    if (gender != null) 'gender': gender,
    if (birthDate != null) 'birth_date': birthDate,
  };
}
