import 'package:carfy/data/models/product/product_model.dart';

class CheckoutPreviewItemModel {
  final int quantity;
  final double price;
  final ProductModel product;

  CheckoutPreviewItemModel({
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory CheckoutPreviewItemModel.fromJson(Map<String, dynamic> json) {
    return CheckoutPreviewItemModel(
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
    );
  }
}

class CheckoutPreviewSellerModel {
  final int companyId;
  final String storeCode;
  final List<CheckoutPreviewItemModel> items;
  final double subtotal;
  final double shipping;

  CheckoutPreviewSellerModel({
    required this.companyId,
    required this.storeCode,
    required this.items,
    required this.subtotal,
    required this.shipping,
  });

  factory CheckoutPreviewSellerModel.fromJson(Map<String, dynamic> json) {
    return CheckoutPreviewSellerModel(
      companyId: json['company_id'] as int,
      storeCode: json['store_code'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CheckoutPreviewItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      shipping: (json['shipping'] as num).toDouble(),
    );
  }
}

class CheckoutPreviewModel {
  final List<CheckoutPreviewSellerModel> sellers;
  final double subtotal;
  final double totalShipping;
  final double grandTotal;

  CheckoutPreviewModel({
    required this.sellers,
    required this.subtotal,
    required this.totalShipping,
    required this.grandTotal,
  });

  factory CheckoutPreviewModel.fromJson(Map<String, dynamic> json) {
    return CheckoutPreviewModel(
      sellers: (json['sellers'] as List<dynamic>)
          .map((e) => CheckoutPreviewSellerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      totalShipping: (json['total_shipping'] as num).toDouble(),
      grandTotal: (json['grand_total'] as num).toDouble(),
    );
  }
}
