class FlatCity {
  final int id;
  final String title;
  final String countryTitle;

  FlatCity({required this.id, required this.title, required this.countryTitle});

  String get displayTitle => '$title, $countryTitle';
}
