import 'package:carfy/domain/entities/products/product.dart';

class CheckoutPreviewItem {
  final int quantity;
  final double price;
  final Product product;

  CheckoutPreviewItem({required this.quantity, required this.price, required this.product});
}

class CheckoutPreviewSeller {
  final int companyId;
  final String storeCode;
  final List<CheckoutPreviewItem> items;
  final double subtotal;
  final bool weightWarning;
  final double shipping;
  final int shippingEtaMinutes;
  final bool shippingIsEstimate;
  final bool isSedan;

  CheckoutPreviewSeller({
    required this.companyId,
    required this.storeCode,
    required this.items,
    required this.subtotal,
    required this.weightWarning,
    required this.shipping,
    required this.shippingEtaMinutes,
    required this.shippingIsEstimate,
    required this.isSedan,
  });
}

class CheckoutPreviewReferral {
  final bool freeDeliveryApplied;
  final bool discountApplied;
  final double discountAmount;
  final double subtotalAfterDiscount;
  final double shippingAfterPerk;
  final double grandTotalAfterPerks;
  final bool canUseBalance;
  final double availableBalance;
  final int freeDeliveryRemaining;
  final int discountOrdersRemaining;

  CheckoutPreviewReferral({
    required this.freeDeliveryApplied,
    required this.discountApplied,
    required this.discountAmount,
    required this.subtotalAfterDiscount,
    required this.shippingAfterPerk,
    required this.grandTotalAfterPerks,
    required this.canUseBalance,
    required this.availableBalance,
    required this.freeDeliveryRemaining,
    required this.discountOrdersRemaining,
  });
}

class CheckoutPreview {
  final List<CheckoutPreviewSeller> sellers;
  final double subtotal;
  final double totalShipping;
  final double grandTotal;
  final CheckoutPreviewReferral? referral;

  CheckoutPreview({
    required this.sellers,
    required this.subtotal,
    required this.totalShipping,
    required this.grandTotal,
    this.referral,
  });
}
