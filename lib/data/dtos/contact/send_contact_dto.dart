class SendContactDto {
  final String fullName;
  final String email;
  final String message;

  SendContactDto({required this.fullName, required this.email, required this.message});

  Map<String, dynamic> toJson() => {'full_name': fullName, 'email': email, 'message': message};
}
