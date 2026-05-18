import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

@RoutePage()
class PaymentWebviewPage extends StatefulWidget {
  final String redirectUrl;

  const PaymentWebviewPage({super.key, required this.redirectUrl});

  @override
  State<PaymentWebviewPage> createState() => _PaymentWebviewPageState();
}

class _PaymentWebviewPageState extends State<PaymentWebviewPage> {
  static const _successMarkers = ['/success', 'payment_status=paid', 'payment=success'];
  static const _failureMarkers = ['/fail', '/cancel', 'payment_status=failed'];

  bool _isLoading = true;
  bool _resolved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.bg,
      appBar: CustomAppBar(title: context.localization.paymentTitle),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.redirectUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useShouldOverrideUrlLoading: true,
            ),
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url?.toString() ?? '';
              if (_matchesAny(url, _successMarkers)) {
                _resolve(true);
                return NavigationActionPolicy.CANCEL;
              }
              if (_matchesAny(url, _failureMarkers)) {
                _resolve(false);
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
            onLoadStart: (_, url) {
              setState(() => _isLoading = true);
              final urlStr = url?.toString() ?? '';
              if (_matchesAny(urlStr, _successMarkers)) {
                _resolve(true);
              } else if (_matchesAny(urlStr, _failureMarkers)) {
                _resolve(false);
              }
            },
            onLoadStop: (_, __) => setState(() => _isLoading = false),
          ),
          if (_isLoading)
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: CircularProgressIndicator(color: context.theme.colors.primary),
            ),
        ],
      ),
    );
  }

  bool _matchesAny(String url, List<String> markers) {
    final lower = url.toLowerCase();
    return markers.any((m) => lower.contains(m));
  }

  void _resolve(bool success) {
    if (_resolved) return;
    _resolved = true;
    if (mounted) context.router.maybePop(success);
  }
}
