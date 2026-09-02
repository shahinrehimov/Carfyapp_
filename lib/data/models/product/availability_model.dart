import 'package:carfy/data/models/product/availability_today_model.dart';

class AvailabilityModel {
  final bool isOpen;
  final String status;
  final AvailabilityTodayModel? today;
  final String? closesAt;
  final String? opensAt;
  final String? opensAtTime;
  final int? opensAtDayOfWeek;
  final String? message;

  AvailabilityModel({
    required this.isOpen,
    required this.status,
    this.today,
    this.closesAt,
    this.opensAt,
    this.opensAtTime,
    this.opensAtDayOfWeek,
    this.message,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      isOpen: json['is_open'] as bool? ?? false,
      status: json['status'] as String? ?? '',
      today: json['today'] != null ? AvailabilityTodayModel.fromJson(json['today'] as Map<String, dynamic>) : null,
      closesAt: json['closes_at'] as String?,
      opensAt: json['opens_at'] as String?,
      opensAtTime: json['opens_at_time'] as String?,
      opensAtDayOfWeek: json['opens_at_day_of_week'] as int?,
      message: json['message'] as String?,
    );
  }
}
