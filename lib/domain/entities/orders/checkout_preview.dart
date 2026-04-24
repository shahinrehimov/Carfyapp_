import 'package:carfy/domain/entities/products/product.dart';

class CheckoutPreviewItem {
  final int quantity;
  final double price;
  final Product product;

  CheckoutPreviewItem({
    required this.quantity,
    required this.price,
    required this.product,
  });
}

class CheckoutPreviewSeller {
  final int companyId;
  final String storeCode;
  final List<CheckoutPreviewItem> items;
  final double subtotal;
  final double shipping;

  CheckoutPreviewSeller({
    required this.companyId,
    required this.storeCode,
    required this.items,
    required this.subtotal,
    required this.shipping,
  });
}

class CheckoutPreview {
  final List<CheckoutPreviewSeller> sellers;
  final double subtotal;
  final double totalShipping;
  final double grandTotal;

  CheckoutPreview({
    required this.sellers,
    required this.subtotal,
    required this.totalShipping,
    required this.grandTotal,
  });
}
