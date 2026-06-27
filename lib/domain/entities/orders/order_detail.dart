class OrderDetail {
  final int id;
  final String code;
  final String uuid;
  final int productsCount;
  final String status;
  final String statusLabel;
  final String date;
  final double amount;
  final double amountFinal;
  final OrderPaymentMethod paymentMethod;
  final OrderAddress address;
  final List<OrderStatusTree> statusTree;
  final List<OrderStatusHistory> statuses;
  final List<OrderItem> items;

  OrderDetail({
    required this.id,
    required this.code,
    required this.uuid,
    required this.productsCount,
    required this.status,
    required this.statusLabel,
    required this.date,
    required this.amount,
    required this.amountFinal,
    required this.paymentMethod,
    required this.address,
    required this.statusTree,
    required this.statuses,
    required this.items,
  });
}

class OrderPaymentMethod {
  final String name;
  final String label;
  final String paymentStatus;
  final String paymentStatusLabel;

  OrderPaymentMethod({
    required this.name,
    required this.label,
    required this.paymentStatus,
    required this.paymentStatusLabel,
  });
}

class OrderAddress {
  final OrderAddressType addressType;
  final OrderCity city;
  final String addressLine1;
  final String? addressLine2;
  final String? latitude;
  final String? longitude;
  final String? phone;

  OrderAddress({
    required this.addressType,
    required this.city,
    required this.addressLine1,
    this.addressLine2,
    this.latitude,
    this.longitude,
    this.phone,
  });
}

class OrderAddressType {
  final int id;
  final String title;

  OrderAddressType({required this.id, required this.title});
}

class OrderCity {
  final int id;
  final String title;

  OrderCity({required this.id, required this.title});
}

class OrderStatusTree {
  final String status;
  final String statusLabel;
  final bool isChecked;
  final String? date;

  OrderStatusTree({required this.status, required this.statusLabel, required this.isChecked, this.date});
}

class OrderStatusHistory {
  final int id;
  final String status;
  final String statusLabel;
  final String date;

  OrderStatusHistory({required this.id, required this.status, required this.statusLabel, required this.date});
}

class OrderItem {
  final int quantity;
  final double amount;
  final double amountFinal;
  final OrderItemProduct product;

  OrderItem({required this.quantity, required this.amount, required this.amountFinal, required this.product});
}

class OrderItemProduct {
  final String uuid;
  final String variantSlug;
  final String title;
  final String? oemCode;
  final String? hoverImage;
  final double price;
  final double priceFinal;
  final bool hasDiscount;
  final double discount;
  final OrderItemSeller seller;

  OrderItemProduct({
    required this.uuid,
    required this.variantSlug,
    required this.title,
    this.oemCode,
    this.hoverImage,
    required this.price,
    required this.priceFinal,
    required this.hasDiscount,
    required this.discount,
    required this.seller,
  });
}

class OrderItemSeller {
  final String uuid;
  final String storeCode;
  final String label;
  final OrderCity city;

  OrderItemSeller({required this.uuid, required this.storeCode, required this.label, required this.city});
}
