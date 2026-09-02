import 'package:carfy/domain/entities/products/availability.dart';
import 'package:carfy/domain/entities/products/city.dart';
import 'package:carfy/domain/entities/products/working_hour.dart';

class Seller {
  final String uuid;
  final String? storeCode;
  final String? label;
  final City? city;
  final List<String> images;
  final Availability? availability;
  final List<WorkingHour> workingHours;

  Seller({
    required this.uuid,
    this.storeCode,
    this.label,
    this.city,
    this.images = const [],
    this.availability,
    this.workingHours = const [],
  });
}
