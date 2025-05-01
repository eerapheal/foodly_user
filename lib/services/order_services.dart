import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:foodly_user/controllers/check_out_controller.dart';
import 'package:foodly_user/controllers/order_controller.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/models/order_item.dart';
import 'package:foodly_user/models/order_response.dart';
import 'package:foodly_user/services/api_services.dart';
import 'package:get/get.dart';

class OrderService extends ApiService {

  // Create Order
  Future<OrderResponse?> createOrder(String orderJson, Order item) async {
    var url = Uri.parse('${Environment.appBaseUrl}/api/orders');
    var response = await makeHttpRequest(
        'POST',
        url,
        headers: getAuthHeaders(),
        body: orderJson,
    );
    // Decode the response body into a Map
    var decodedResponse = response["data"];
    box.write("orderId", decodedResponse["orderId"]);

    if (response['status'] == 201) {
      // Parse the data using the OrderResponse model
      OrderResponse data = OrderResponse.fromJson(decodedResponse);
      //orderController.orderPrice - orderController.finalAmount
      box.write("orderPrice", Get.find<OrderController>().orderPrice.toString());

      box.write("finalAmount", Get.find<OrderController>().finalAmount.toString());

      box.write("totalPrice", Get.find<CartCheckoutController>().totalPrice.toString());
      final orderPrice = jsonDecode(box.read("orderPrice"));
      final finalAmount = jsonDecode(box.read("finalAmount"));
      final totalPrice = jsonDecode(box.read("totalPrice"));
      print("My total orderPrice is ${orderPrice}");
      print("My finalAmount  is ${finalAmount}");
      print("My totalPrice is ${totalPrice}");
      return data;
    } else {
      print('Failed to create order: ${response['data']['message']}');
      return null;
    }
  }
// Payment function with generalized usage and error handling
  Future<Map<String, dynamic>> paymentFunction(
      String paymentData, String paymentMethod) async {
    try {
      var url = paymentMethod == "Stripe"
          ? (kIsWeb
          ? Uri.parse('${Environment.paymentUrl}/stripe/create-checkout-web-session')
          : Uri.parse('${Environment.paymentUrl}/stripe/create-checkout-session'))
          : Uri.parse('${Environment.paymentUrl}/paystack-create-payment/${kIsWeb ? "web" : "mobile"}');

      print("URL is $url");
      print("Is web: $kIsWeb");

      // Making the HTTP request with error handling
      var response = await makeHttpRequest(
        'POST',
        url,
        headers: {'Content-Type': 'application/json'},
        body: paymentData,
      );
      print("my restponse stats is ${response['status']}");
      if (response['status'] == 200) {
        if (paymentMethod == 'Stripe') {
          if (kIsWeb) {
            // Extract sessionId from the response for Stripe
            String sessionId = response['data']['sessionId'];
            print("Stripe session ID: $sessionId");

            // For embedded mode, return the sessionId instead of paymentUrl
            return {'success': true, 'sessionId': sessionId};
          } else {
            String paymentUrl = response['data']['paymentUrl'];
            print("Stripe payment URL: $paymentUrl");
            return {'success': true, 'paymentUrl': paymentUrl};
          }
        } else if (paymentMethod == 'Paystack') {

          String paymentUrl = response['data']['paymentUrl'];
          print("Paystack payment URL: $paymentUrl");
          return {'success': true, 'paymentUrl': paymentUrl};
        }
      }

      // Fallback if the status code is not 200
      print("Payment failed with status: ${response['status']}");
      return {'success': false, 'paymentUrl': null};
    } catch (e) {
      // Catching any exceptions that occur during the request
      print("Error during payment processing: $e");
      return {'success': false, 'error': e.toString()};
    }
  }

  // Update order confirmation
  Future<bool> updateConfirmation(String orderId) async {
    var url = Uri.parse('${Environment.appBaseUrl}/api/orders/confirm/$orderId');
    var response = await makeHttpRequest(
        'PUT',
        url,
        headers: getAuthHeaders()
    );
    return response['status'] == 200;
  }

  // Loyalty points transaction
  Future<bool> loyaltyTransaction(Map<String, dynamic> loyaltyTransactionJson) async {
    var url = Uri.parse('${Environment.appBaseUrl}/api/points/points');
    var response = await makeHttpRequest(
        'POST',
        url,
        headers: getAuthHeaders(),
        body: jsonEncode(loyaltyTransactionJson)
    );

    if (response['status'] == 201) {
      return true;
    } else {
      print('Error during loyalty transaction: ${response['data']}');
      return false;
    }
  }

}
