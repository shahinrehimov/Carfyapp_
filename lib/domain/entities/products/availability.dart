import 'package:carfy/domain/entities/products/availability_today.dart';

class Availability {
  final bool isOpen;
  final String status;
  final AvailabilityToday? today;
  final String? closesAt;
  final String? opensAt;
  final String? opensAtTime;
  final int? opensAtDayOfWeek;
  final String? message;

  Availability({
    required this.isOpen,
    required this.status,
    this.today,
    this.closesAt,
    this.opensAt,
    this.opensAtTime,
    this.opensAtDayOfWeek,
    this.message,
  });
}
