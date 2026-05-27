class AppNotificationModel {
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

  AppNotificationModel({
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

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      image: json['image'] as String?,
      actionType: json['action_type'] as String,
      actionId: json['action_id'] as String?,
      isRead: json['is_read'] as bool,
      date: json['date'] as String,
      dateRaw: json['date_raw'] as String,
    );
  }
}
