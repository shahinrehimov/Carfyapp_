class City {
  final int id;
  final String title;
  final int countryId;

  City({required this.id, required this.title, required this.countryId});
}

class Country {
  final int id;
  final String title;
  final List<City> cities;

  Country({required this.id, required this.title, required this.cities});
}
