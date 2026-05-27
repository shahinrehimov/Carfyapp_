class AppNotification {
  final int id;
  final String uuid;
  final String title;
  final String body;
  final String? image;
  final String actionType;
  final String? actionId;
  final bool isRead;
  final String date;
  final String dateRaw;

  AppNotification({
    required this.id,
    required this.uuid,
    required this.title,
    required this.body,
    this.image,
    required this.actionType,
    this.actionId,
    required this.isRead,
    required this.date,
    required this.dateRaw,
  });
}
