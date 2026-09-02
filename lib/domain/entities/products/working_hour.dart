class WorkingHour {
  final int dayOfWeek;
  final bool isClosed;
  final String? openTime;
  final String? closeTime;

  WorkingHour({required this.dayOfWeek, required this.isClosed, this.openTime, this.closeTime});
}
