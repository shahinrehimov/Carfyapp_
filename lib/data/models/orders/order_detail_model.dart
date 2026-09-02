class OrderDetailModel {
  final int id;
  final String code;
  final String uuid;
  final int productsCount;
  final String status;
  final String statusLabel;
  final String date;
  final double amount;
  final double amountFinal;
  final OrderPaymentMethodModel paymentMethod;
  final OrderAddressModel address;
  final List<OrderStatusTreeModel> statusTree;
  final List<OrderStatusHistoryModel> statuses;
  final List<OrderItemModel> items;

  OrderDetailModel({
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

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'] as int,
      code: json['code'] as String,
      uuid: json['uuid'] as String,
      productsCount: json['products_count'] as int,
      status: json['status'] as String,
      statusLabel: json['status_label'] as String,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
      amountFinal: (json['amount_final'] as num).toDouble(),
      paymentMethod: OrderPaymentMethodModel.fromJson(json['payment_method'] as Map<String, dynamic>),
      address: OrderAddressModel.fromJson(json['address'] as Map<String, dynamic>),
      statusTree: (json['status_tree'] as List)
          .map((e) => OrderStatusTreeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      statuses: (json['statuses'] as List)
          .map((e) => OrderStatusHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      items: (json['items'] as List).map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class OrderPaymentMethodModel {
  final String name;
  final String label;
  final String paymentStatus;
  final String paymentStatusLabel;

  OrderPaymentMethodModel({
    required this.name,
    required this.label,
    required this.paymentStatus,
    required this.paymentStatusLabel,
  });

  factory OrderPaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return OrderPaymentMethodModel(
      name: json['name'] as String,
      label: json['label'] as String,
      paymentStatus: json['payment_status'] as String,
      paymentStatusLabel: json['payment_status_label'] as String,
    );
  }
}

class OrderAddressModel {
  final OrderAddressTypeModel addressType;
  final OrderCityModel city;
  final String addressLine1;
  final String? addressLine2;
  final String? latitude;
  final String? longitude;
  final String? phone;

  OrderAddressModel({
    required this.addressType,
    required this.city,
    required this.addressLine1,
    this.addressLine2,
    this.latitude,
    this.longitude,
    this.phone,
  });

  factory OrderAddressModel.fromJson(Map<String, dynamic> json) {
    return OrderAddressModel(
      addressType: OrderAddressTypeModel.fromJson(json['address_type'] as Map<String, dynamic>),
      city: OrderCityModel.fromJson(json['city'] as Map<String, dynamic>),
      addressLine1: json['address_line_1'] as String,
      addressLine2: json['address_line_2'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      phone: json['phone'] as String?,
    );
  }
}

class OrderAddressTypeModel {
  final int id;
  final String title;

  OrderAddressTypeModel({required this.id, required this.title});

  factory OrderAddressTypeModel.fromJson(Map<String, dynamic> json) {
    return OrderAddressTypeModel(id: json['id'] as int, title: json['title'] as String);
  }
}

class OrderCityModel {
  final int id;
  final String title;

  OrderCityModel({required this.id, required this.title});

  factory OrderCityModel.fromJson(Map<String, dynamic> json) {
    return OrderCityModel(id: json['id'] as int, title: json['title'] as String);
  }
}

class OrderStatusTreeModel {
  final String status;
  final String statusLabel;
  final bool isChecked;
  final String? date;

  OrderStatusTreeModel({required this.status, required this.statusLabel, required this.isChecked, this.date});

  factory OrderStatusTreeModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusTreeModel(
      status: json['status'] as String,
      statusLabel: json['status_label'] as String,
      isChecked: json['is_checked'] as bool,
      date: json['date'] as String?,
    );
  }
}

class OrderStatusHistoryModel {
  final int id;
  final String status;
  final String statusLabel;
  final String date;

  OrderStatusHistoryModel({required this.id, required this.status, required this.statusLabel, required this.date});

  factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistoryModel(
      id: json['id'] as int,
      status: json['status'] as String,
      statusLabel: json['status_label'] as String,
      date: json['date'] as String,
    );
  }
}

class OrderItemModel {
  final int quantity;
  final double amount;
  final double amountFinal;
  final OrderItemProductModel product;

  OrderItemModel({required this.quantity, required this.amount, required this.amountFinal, required this.product});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      quantity: json['quantity'] as int,
      amount: (json['amount'] as num).toDouble(),
      amountFinal: (json['amount_final'] as num).toDouble(),
      product: OrderItemProductModel.fromJson(json['product'] as Map<String, dynamic>),
    );
  }
}

class OrderItemProductModel {
  final String uuid;
  final String title;
  final String? oemCode;
  final String? hoverImage;
  final double price;
  final double priceFinal;
  final bool hasDiscount;
  final double discount;
  final OrderItemSellerModel seller;

  OrderItemProductModel({
    required this.uuid,
    required this.title,
    this.oemCode,
    this.hoverImage,
    required this.price,
    required this.priceFinal,
    required this.hasDiscount,
    required this.discount,
    required this.seller,
  });

  factory OrderItemProductModel.fromJson(Map<String, dynamic> json) {
    return OrderItemProductModel(
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      oemCode: json['oem_code'] as String?,
      hoverImage: json['hover_image'] as String?,
      price: (json['price'] as num).toDouble(),
      priceFinal: (json['price_final'] as num).toDouble(),
      hasDiscount: json['has_discount'] as bool,
      discount: (json['discount'] as num).toDouble(),
      seller: OrderItemSellerModel.fromJson(json['seller'] as Map<String, dynamic>),
    );
  }
}

class OrderItemSellerModel {
  final String uuid;
  final String storeCode;
  final String label;
  final OrderCityModel city;

  OrderItemSellerModel({required this.uuid, required this.storeCode, required this.label, required this.city});

  factory OrderItemSellerModel.fromJson(Map<String, dynamic> json) {
    return OrderItemSellerModel(
      uuid: json['uuid'] as String,
      storeCode: json['store_code'] as String,
      label: json['label'] as String,
      city: OrderCityModel.fromJson(json['city'] as Map<String, dynamic>),
    );
  }
}
