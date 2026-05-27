import 'package:carfy/data/mappers/product_mapper.dart';
import 'package:carfy/data/models/orders/checkout_preview_model.dart';
import 'package:carfy/data/models/orders/checkout_result_model.dart';
import 'package:carfy/data/models/orders/order_summary_model.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/domain/entities/orders/checkout_result.dart';
import 'package:carfy/domain/entities/orders/order_summary.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrderMapper {
  final ProductMapper _productMapper;

  OrderMapper(this._productMapper);

  CheckoutResult mapCheckoutResult(CheckoutResultModel model) => CheckoutResult(
        message: model.message,
        redirect: model.redirect,
        redirectUrl: model.redirectUrl,
      );

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
        shipping: model.shipping,
      );

  CheckoutPreview mapCheckoutPreview(CheckoutPreviewModel model) => CheckoutPreview(
        sellers: model.sellers.map(mapSeller).toList(),
        subtotal: model.subtotal,
        totalShipping: model.totalShipping,
        grandTotal: model.grandTotal,
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
}
