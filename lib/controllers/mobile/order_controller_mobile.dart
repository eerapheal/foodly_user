String processStripePaymentMobile(Map<String, dynamic> paymentResult, Function(bool, String?) onPaymentInitiated) {
  if (paymentResult['success']) {
    final paymentUrl = paymentResult['paymentUrl'];
    onPaymentInitiated(true, paymentUrl);
    print("Mobile Payment URL: $paymentUrl");
    return paymentUrl;
  } else {
    onPaymentInitiated(false, null);
    return "";
  }
}

String processPaystackPaymentMobile(Map<String, dynamic> paymentResult, Function(bool, String?) onPaymentInitiated) {
  if (paymentResult['success']) {
    final paymentUrl = paymentResult['paymentUrl'];
    onPaymentInitiated(true, paymentUrl);
    print("Mobile Payment URL: $paymentUrl");
    return paymentUrl;
  } else {
    onPaymentInitiated(false, null);
    return "";
  }
}



