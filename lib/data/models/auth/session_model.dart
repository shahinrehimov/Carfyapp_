class SessionModel {
  final int id;
  final String deviceName;
  final String? ipAddress;
  final String? location;
  final String createdAt;
  final bool isCurrent;

  SessionModel({
    required this.id,
    required this.deviceName,
    this.ipAddress,
    this.location,
    required this.createdAt,
    required this.isCurrent,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    id: json['id'],
    deviceName: json['device_name'] ?? '',
    ipAddress: json['ip_address'],
    location: json['location'],
    createdAt: json['created_at'] ?? '',
    isCurrent: json['is_current'] ?? false,
  );
}
