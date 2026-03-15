class Session {
  final int id;
  final String deviceName;
  final String? ipAddress;
  final String? location;
  final String createdAt;
  final bool isCurrent;

  const Session({
    required this.id,
    required this.deviceName,
    this.ipAddress,
    this.location,
    required this.createdAt,
    required this.isCurrent,
  });
}
