/*
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripePaymentWebView extends StatelessWidget {
  final String paymentUrl;

  const StripePaymentWebView({Key? key, required this.paymentUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stripe Payment")),
      body: WebView(
        initialUrl: paymentUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (String url) {
          // Check if the URL is the success or cancel URL to close the WebView
          if (url.contains("checkout-success")) {
            Navigator.pop(context, "Payment Successful");
          } else if (url.contains("checkout-cancel")) {
            Navigator.pop(context, "Payment Canceled");
          }
        },
      ),
    );
  }
}
*/
