import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/presentation/payment_webview/state/payment_webview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

@RoutePage()
class PaymentWebviewPage extends StatelessWidget implements AutoRouteWrapper {
  final String redirectUrl;

  const PaymentWebviewPage({super.key, required this.redirectUrl});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => PaymentWebviewCubit(), child: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.bg,
      appBar: CustomAppBar(title: context.localization.paymentTitle),
      body: BlocListener<PaymentWebviewCubit, PaymentWebviewState>(
        listenWhen: (prev, curr) => prev.outcome != curr.outcome && curr.outcome != null,
        listener: (context, state) => context.router.maybePop(state.outcome),
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(redirectUrl)),
              initialSettings: InAppWebViewSettings(javaScriptEnabled: true, useShouldOverrideUrlLoading: true),
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final uri = navigationAction.request.url;
                final cubit = context.read<PaymentWebviewCubit>();
                if (uri != null && cubit.isPaymentStatusUrl(uri)) {
                  cubit.handlePaymentStatusUrl(uri);
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
              onLoadStart: (_, url) {
                final cubit = context.read<PaymentWebviewCubit>();
                cubit.setWebviewLoading(true);
                if (url != null && cubit.isPaymentStatusUrl(url)) {
                  cubit.handlePaymentStatusUrl(url);
                }
              },
              onLoadStop: (_, __) => context.read<PaymentWebviewCubit>().setWebviewLoading(false),
            ),
            BlocBuilder<PaymentWebviewCubit, PaymentWebviewState>(
              buildWhen: (prev, curr) => prev.showOverlay != curr.showOverlay,
              builder: (context, state) {
                if (!state.showOverlay) return const SizedBox.shrink();
                return Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(color: context.theme.colors.primary),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
