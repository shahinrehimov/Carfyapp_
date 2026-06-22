import 'package:carfy/common/di/di.dart';
import 'package:carfy/domain/params/orders/check_payment_status_params.dart';
import 'package:carfy/domain/use_cases/orders/check_payment_status_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_webview_state.dart';

class PaymentWebviewCubit extends Cubit<PaymentWebviewState> {
  static const _statusPathFragment = '/payment-status';

  // /check-payment-status returns one of: paid, failed, pending, refunded.
  static const _paidStatuses = {'paid'};

  final CheckPaymentStatusUseCase _checkPaymentStatusUseCase;

  PaymentWebviewCubit({CheckPaymentStatusUseCase? checkPaymentStatusUseCase})
    : _checkPaymentStatusUseCase = checkPaymentStatusUseCase ?? getIt<CheckPaymentStatusUseCase>(),
      super(PaymentWebviewState.initial());

  void setWebviewLoading(bool loading) {
    if (state.outcome != null) return;
    emit(state.copyWith(webviewLoading: loading));
  }

  bool isPaymentStatusUrl(Uri uri) => uri.path.toLowerCase().contains(_statusPathFragment);

  Future<void> handlePaymentStatusUrl(Uri uri) async {
    if (state.outcome != null || state.isVerifying) return;

    final orderUuid = uri.queryParameters['order'];
    final method = uri.queryParameters['method'];
    final token = uri.queryParameters['token'];

    if (orderUuid == null || method == null || token == null) {
      emit(state.copyWith(outcome: false));
      return;
    }

    emit(state.copyWith(isVerifying: true));

    final result = await _checkPaymentStatusUseCase(
      CheckPaymentStatusParams(orderUuid: orderUuid, paymentMethod: method, token: token),
    );

    result.fold(
      (_) => emit(state.copyWith(isVerifying: false, outcome: false)),
      (status) => emit(state.copyWith(isVerifying: false, outcome: _paidStatuses.contains(status.toLowerCase()))),
    );
  }
}
