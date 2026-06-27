part of 'payment_webview_cubit.dart';

class PaymentWebviewState extends Equatable {
  final bool webviewLoading;
  final bool isVerifying;
  final bool? outcome;

  const PaymentWebviewState({required this.webviewLoading, required this.isVerifying, this.outcome});

  factory PaymentWebviewState.initial() => const PaymentWebviewState(webviewLoading: true, isVerifying: false);

  bool get showOverlay => webviewLoading || isVerifying;

  PaymentWebviewState copyWith({bool? webviewLoading, bool? isVerifying, bool? outcome}) {
    return PaymentWebviewState(
      webviewLoading: webviewLoading ?? this.webviewLoading,
      isVerifying: isVerifying ?? this.isVerifying,
      outcome: outcome ?? this.outcome,
    );
  }

  @override
  List<Object?> get props => [webviewLoading, isVerifying, outcome];
}
