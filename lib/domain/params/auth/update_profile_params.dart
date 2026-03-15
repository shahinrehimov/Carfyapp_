class UpdateProfileParams {
  final String name;
  final String surname;
  final String? gender;
  final String? birthDate; // format: dd.MM.yyyy

  const UpdateProfileParams({
    required this.name,
    required this.surname,
    this.gender,
    this.birthDate,
  });
}
