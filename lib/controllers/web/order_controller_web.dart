// order_controller_web.dart
// // // // // // // // START_DISABLE
// import 'dart:js' as js;
// 
// void processStripePaymentWeb(Map<String, dynamic> paymentResult) {
// if (paymentResult['success']) {
// final paymentUrl = paymentResult.containsKey('sessionId')
// ? paymentResult['sessionId'] // Stripe sessionId
// : paymentResult['paymentUrl'];
// 
// js.context
// .callMethod('redirectToStripeCheckout', [paymentResult['sessionId']]);
// print("Web Payment session ID: $paymentUrl");
// }
// }
// 
// void processPaystackPaymentWeb(String email, double amount, String reference) {
// js.context.callMethod('payWithPaystack', [
// email,
// (amount * 100).toInt(), // Convert to kobo
// reference
// ]);
// }
// // // // // // // // END_DISABLE
