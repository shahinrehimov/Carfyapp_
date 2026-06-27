import 'package:carfy/data/models/payment/payment_method_model.dart';
import 'package:carfy/domain/entities/payment/payment_method.dart';
import 'package:injectable/injectable.dart';

@injectable
class PaymentMapper {
  PaymentMethod mapPaymentMethod(PaymentMethodModel model) =>
      PaymentMethod(value: model.value, label: model.label, requiredFields: model.requiredFields);
}
