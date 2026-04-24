class CityModel {
  final int id;
  final String title;
  final int countryId;

  CityModel({required this.id, required this.title, required this.countryId});

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json['id'] as int,
        title: json['title'] as String,
        countryId: json['country_id'] as int,
      );
}

class CountryModel {
  final int id;
  final String title;
  final List<CityModel> cities;

  CountryModel({required this.id, required this.title, required this.cities});

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json['id'] as int,
        title: json['title'] as String,
        cities: (json['cities'] as List<dynamic>)
            .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
