import 'package:carfy/data/models/orders/closed_seller_model.dart';
import 'package:carfy/data/models/product/availability_model.dart';
import 'package:carfy/data/models/product/product_model.dart';

class CheckoutPreviewItemModel {
  final int quantity;
  final double price;
  final ProductModel product;

  CheckoutPreviewItemModel({required this.quantity, required this.price, required this.product});

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
  final bool weightWarning;
  final double shipping;
  final int shippingEtaMinutes;
  final bool shippingIsEstimate;
  final bool isSedan;
  final bool isOpen;
  final AvailabilityModel? availability;

  CheckoutPreviewSellerModel({
    required this.companyId,
    required this.storeCode,
    required this.items,
    required this.subtotal,
    required this.weightWarning,
    required this.shipping,
    required this.shippingEtaMinutes,
    required this.shippingIsEstimate,
    required this.isSedan,
    required this.isOpen,
    this.availability,
  });

  factory CheckoutPreviewSellerModel.fromJson(Map<String, dynamic> json) {
    return CheckoutPreviewSellerModel(
      companyId: json['company_id'] as int,
      storeCode: json['store_code'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CheckoutPreviewItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      weightWarning: json['weight_warning'] as bool,
      shipping: (json['shipping'] as num).toDouble(),
      shippingEtaMinutes: json['shipping_eta_minutes'] as int,
      shippingIsEstimate: json['shipping_is_estimate'] as bool,
      isSedan: json['is_sedan'] as bool,
      isOpen: json['is_open'] as bool? ?? true,
      availability: json['availability'] != null
          ? AvailabilityModel.fromJson(json['availability'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CheckoutPreviewReferralModel {
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

  CheckoutPreviewReferralModel({
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

  factory CheckoutPreviewReferralModel.fromJson(Map<String, dynamic> json) {
    return CheckoutPreviewReferralModel(
      freeDeliveryApplied: json['free_delivery_applied'] as bool,
      discountApplied: json['discount_applied'] as bool,
      discountAmount: (json['discount_amount'] as num).toDouble(),
      subtotalAfterDiscount: (json['subtotal_after_discount'] as num).toDouble(),
      shippingAfterPerk: (json['shipping_after_perk'] as num).toDouble(),
      grandTotalAfterPerks: (json['grand_total_after_perks'] as num).toDouble(),
      canUseBalance: json['can_use_balance'] as bool,
      availableBalance: (json['available_balance'] as num).toDouble(),
      freeDeliveryRemaining: json['free_delivery_remaining'] as int,
      discountOrdersRemaining: json['discount_orders_remaining'] as int,
    );
  }
}

class CheckoutPreviewModel {
  final List<CheckoutPreviewSellerModel> sellers;
  final double subtotal;
  final double totalShipping;
  final double grandTotal;
  final CheckoutPreviewReferralModel? referral;
  final bool canCheckout;
  final List<ClosedSellerModel> closedSellers;

  CheckoutPreviewModel({
    required this.sellers,
    required this.subtotal,
    required this.totalShipping,
    required this.grandTotal,
    this.referral,
    required this.canCheckout,
    this.closedSellers = const [],
  });

  factory CheckoutPreviewModel.fromJson(Map<String, dynamic> json) {
    return CheckoutPreviewModel(
      sellers: (json['sellers'] as List<dynamic>)
          .map((e) => CheckoutPreviewSellerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      totalShipping: (json['total_shipping'] as num).toDouble(),
      grandTotal: (json['grand_total'] as num).toDouble(),
      referral: json['referral'] != null
          ? CheckoutPreviewReferralModel.fromJson(json['referral'] as Map<String, dynamic>)
          : null,
      canCheckout: json['can_checkout'] as bool? ?? true,
      closedSellers: json['closed_sellers'] != null
          ? (json['closed_sellers'] as List<dynamic>)
              .map((e) => ClosedSellerModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}
