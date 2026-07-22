import 'package:carfy/data/mappers/product_mapper.dart';
import 'package:carfy/data/models/orders/checkout_preview_model.dart';
import 'package:carfy/data/models/orders/checkout_result_model.dart';
import 'package:carfy/data/models/orders/order_detail_model.dart';
import 'package:carfy/data/models/orders/order_summary_model.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/domain/entities/orders/checkout_result.dart';
import 'package:carfy/domain/entities/orders/order_detail.dart';
import 'package:carfy/domain/entities/orders/order_summary.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrderMapper {
  final ProductMapper _productMapper;

  OrderMapper(this._productMapper);

  CheckoutResult mapCheckoutResult(CheckoutResultModel model) =>
      CheckoutResult(message: model.message, redirect: model.redirect, redirectUrl: model.redirectUrl);

  CheckoutPreviewItem mapItem(CheckoutPreviewItemModel model) => CheckoutPreviewItem(
    quantity: model.quantity,
    price: model.price,
    product: _productMapper.mapProduct(model.product),
  );

  CheckoutPreviewSeller mapSeller(CheckoutPreviewSellerModel model) => CheckoutPreviewSeller(
    companyId: model.companyId,
    storeCode: model.storeCode,
    items: model.items.map(mapItem).toList(),
    subtotal: model.subtotal,
    weightWarning: model.weightWarning,
    shipping: model.shipping,
    shippingEtaMinutes: model.shippingEtaMinutes,
    shippingIsEstimate: model.shippingIsEstimate,
    isSedan: model.isSedan,
  );

  CheckoutPreviewReferral? _mapReferral(CheckoutPreviewReferralModel? model) {
    if (model == null) return null;
    return CheckoutPreviewReferral(
      freeDeliveryApplied: model.freeDeliveryApplied,
      discountApplied: model.discountApplied,
      discountAmount: model.discountAmount,
      subtotalAfterDiscount: model.subtotalAfterDiscount,
      shippingAfterPerk: model.shippingAfterPerk,
      grandTotalAfterPerks: model.grandTotalAfterPerks,
      canUseBalance: model.canUseBalance,
      availableBalance: model.availableBalance,
      freeDeliveryRemaining: model.freeDeliveryRemaining,
      discountOrdersRemaining: model.discountOrdersRemaining,
    );
  }

  CheckoutPreview mapCheckoutPreview(CheckoutPreviewModel model) => CheckoutPreview(
    sellers: model.sellers.map(mapSeller).toList(),
    subtotal: model.subtotal,
    totalShipping: model.totalShipping,
    grandTotal: model.grandTotal,
    referral: _mapReferral(model.referral),
  );

  OrderSummary mapOrderSummary(OrderSummaryModel model) => OrderSummary(
    id: model.id,
    code: model.code,
    uuid: model.uuid,
    productsCount: model.productsCount,
    status: model.status,
    statusLabel: model.statusLabel,
    date: model.date,
  );

  OrderDetail mapOrderDetail(OrderDetailModel model) => OrderDetail(
    id: model.id,
    code: model.code,
    uuid: model.uuid,
    productsCount: model.productsCount,
    status: model.status,
    statusLabel: model.statusLabel,
    date: model.date,
    amount: model.amount,
    amountFinal: model.amountFinal,
    paymentMethod: OrderPaymentMethod(
      name: model.paymentMethod.name,
      label: model.paymentMethod.label,
      paymentStatus: model.paymentMethod.paymentStatus,
      paymentStatusLabel: model.paymentMethod.paymentStatusLabel,
    ),
    address: OrderAddress(
      addressType: OrderAddressType(id: model.address.addressType.id, title: model.address.addressType.title),
      city: OrderCity(id: model.address.city.id, title: model.address.city.title),
      addressLine1: model.address.addressLine1,
      addressLine2: model.address.addressLine2,
      latitude: model.address.latitude,
      longitude: model.address.longitude,
      phone: model.address.phone,
    ),
    statusTree: model.statusTree
        .map((e) => OrderStatusTree(status: e.status, statusLabel: e.statusLabel, isChecked: e.isChecked, date: e.date))
        .toList(),
    statuses: model.statuses
        .map((e) => OrderStatusHistory(id: e.id, status: e.status, statusLabel: e.statusLabel, date: e.date))
        .toList(),
    items: model.items.map(_mapOrderItem).toList(),
  );

  OrderItem _mapOrderItem(OrderItemModel model) => OrderItem(
    quantity: model.quantity,
    amount: model.amount,
    amountFinal: model.amountFinal,
    product: OrderItemProduct(
      uuid: model.product.uuid,
      title: model.product.title,
      oemCode: model.product.oemCode,
      hoverImage: model.product.hoverImage,
      price: model.product.price,
      priceFinal: model.product.priceFinal,
      hasDiscount: model.product.hasDiscount,
      discount: model.product.discount,
      seller: OrderItemSeller(
        uuid: model.product.seller.uuid,
        storeCode: model.product.seller.storeCode,
        label: model.product.seller.label,
        city: OrderCity(id: model.product.seller.city.id, title: model.product.seller.city.title),
      ),
    ),
  );
}
