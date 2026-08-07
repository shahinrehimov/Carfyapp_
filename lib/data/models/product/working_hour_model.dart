class WorkingHourModel {
  final int dayOfWeek;
  final bool isClosed;
  final String? openTime;
  final String? closeTime;

  WorkingHourModel({required this.dayOfWeek, required this.isClosed, this.openTime, this.closeTime});

  factory WorkingHourModel.fromJson(Map<String, dynamic> json) {
    return WorkingHourModel(
      dayOfWeek: json['day_of_week'] as int,
      isClosed: json['is_closed'] as bool? ?? false,
      openTime: json['open_time'] as String?,
      closeTime: json['close_time'] as String?,
    );
  }
}
