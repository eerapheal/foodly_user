import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PayStackWebView extends StatefulWidget {
  final String email;
  final int amount; // Amount in kobo (1 NGN = 100 kobo)
  final String orderId;
  const PayStackWebView({Key? key, required this.email, required this.amount, required this.orderId}) : super(key: key);

  @override
  State<PayStackWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PayStackWebView> {
  late final WebViewController _controller;
  String? paymentUrl;
  String? successUrl; // Adding success URL to the state
  String? failureUrl; // Adding failure URL to the state

  @override
  void initState() {
    super.initState();
    initiatePayment(widget.email, widget.amount, widget.orderId);
  }

  Future<void> initiatePayment(String email, int amount, String orderId) async {

    final url = 'https://d7d6-43-206-250-208.ngrok-free.app/paystack-create-payment'; // Replace with your ngrok URL
    final body = jsonEncode({
      'email': email,
      'amount': amount,
      'orderId':orderId
    });
    print("body is ${body}");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("my data is $data");
        setState(() {
          paymentUrl = data['paymentUrl'];  // Extract payment URL
          successUrl = data['successUrl'];  // Extract success URL
          failureUrl = data['failureUrl'];  // Extract failure URL
        });
        print("Here we are..............");
        loadPaymentUrl();
      } else {
        print('Failed to initiate payment.........');
      }
    } catch (error) {
      print('Error initiating payment: $error');
    }
  }

  void loadPaymentUrl() {
    if (paymentUrl != null) {
      // Platform-specific webview settings
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final WebViewController controller =
      WebViewController.fromPlatformCreationParams(params);

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('flutter://payment-success')) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Successful()),
                );
                return NavigationDecision.prevent;
              } else if (request.url.startsWith('flutter://payment-failure')) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentFailed()),
                );
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },

          ),
        )
        ..loadRequest(Uri.parse(paymentUrl!));

      _controller = controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 20,
      ),
      body: paymentUrl == null
          ? const Center(child: CircularProgressIndicator()) // Show a loading indicator while fetching the payment URL
          : WebViewWidget(controller: _controller),
    );
  }
}

class Successful extends StatelessWidget {
  const Successful({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Payment Successful', style: TextStyle(
          fontSize: 38
      ),)),
    );
  }
}

class PaymentFailed extends StatelessWidget {
  const PaymentFailed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Payment Failed')),
    );
  }
}