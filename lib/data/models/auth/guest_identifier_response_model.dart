class GuestIdentifierResponseModel {
  final String identifier;
  final String message;

  GuestIdentifierResponseModel({required this.identifier, required this.message});

  factory GuestIdentifierResponseModel.fromJson(Map<String, dynamic> json) {
    return GuestIdentifierResponseModel(identifier: json['identifier'] ?? '', message: json['message'] ?? '');
  }
}
