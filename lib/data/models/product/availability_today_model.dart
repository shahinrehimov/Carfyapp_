class AvailabilityTodayModel {
  final bool isClosed;
  final String? openTime;
  final String? closeTime;

  AvailabilityTodayModel({required this.isClosed, this.openTime, this.closeTime});

  factory AvailabilityTodayModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityTodayModel(
      isClosed: json['is_closed'] as bool? ?? false,
      openTime: json['open_time'] as String?,
      closeTime: json['close_time'] as String?,
    );
  }
}
