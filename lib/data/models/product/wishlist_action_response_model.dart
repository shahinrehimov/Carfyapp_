class WishlistActionResponseModel {
  final String message;

  WishlistActionResponseModel({required this.message});

  factory WishlistActionResponseModel.fromJson(Map<String, dynamic> json) {
    return WishlistActionResponseModel(message: json['message'] as String);
  }
}
