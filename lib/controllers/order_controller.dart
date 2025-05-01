// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'mobile/order_controller_mobile.dart';
import 'web/order_controller_web.dart'
    if (dart.library.io) 'mobile/order_controller_mobile.dart';
import 'package:foodly_user/models/loyalty_transaction.dart';
import 'package:foodly_user/models/order_item.dart';
import 'package:foodly_user/models/payment_request.dart';
import 'package:foodly_user/models/user_cart.dart';
import 'package:foodly_user/services/order_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OrderController extends GetxController implements GetxService {
  final OrderService _orderService = OrderService();

  final RxString _orderId = ''.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _iconChanger = false.obs;

  final RxString _paymentUrl = ''.obs;

  //set from multi cart page
  final RxDouble _orderPrice = 0.0.obs;

  //used if we have coupons or credits to count
  final RxDouble _finalAmount = 0.0.obs;

  //save given redeemable amount
  final RxDouble _redeemableAmount = 0.0.obs;

  //check if the redeem is being used or not;
  final RxBool _useRedeem = false.obs;

  var confirmation = false.obs; // Observable confirmation

  String _paymentMethod = "";
  Order? order;

  // Getters
  String get orderId => _orderId.value;

  bool get isLoading => _isLoading.value;

  bool get iconChanger => _iconChanger.value;

  bool get useRedeem => _useRedeem.value;

  String get paymentMethod => _paymentMethod;

  String get paymentUrl => _paymentUrl.value;

  double get finalAmount => _finalAmount.value;

  double get redeemableAmount => _redeemableAmount.value;

  double get orderPrice => _orderPrice.value;

  // Setters
  set orderId(String newValue) => _orderId.value = newValue;

  set setLoading(bool newValue) => _isLoading.value = newValue;

  set setIcon(bool newValue) => _iconChanger.value = newValue;

  setPaymentMethod(String newValue) => _paymentMethod = newValue;

  set paymentUrl(String newValue) => _paymentUrl.value = newValue;

  set finalAmount(double finalAmount) => _finalAmount.value = finalAmount;

  set redeemableAmount(double redeemableAmount) =>
      _redeemableAmount.value = redeemableAmount;

  set useRedeem(bool useRedeem) => _useRedeem.value = useRedeem;

  set orderPrice(double price) => _orderPrice.value = price;
  RxList<OrderItem> _orderItems = <OrderItem>[].obs;

  List<OrderItem> get orderItems => _orderItems.value;

  //added in version 3.2.8
  //during payment of multi select
  UserCart? _userCart;

  UserCart? get userCart => _userCart;

  setUserCart(UserCart cart) => _userCart = cart;

  void clearOrderItems() {
    _orderItems.clear();
    update();
    _calculateOrderPrice();
  }

  void _calculateOrderPrice() {
    double total = 0.0;
    for (OrderItem item in _orderItems) {
      total += double.parse(item.price) * int.parse(item.quantity);
    }
    setOrderTotal(total);
  }

  double get totalOrderPrice => _orderPrice.value;

  void setOrderTotal(double tt) {
    _orderPrice.value = tt;
    update();
  }

  Future<void> createOrder(String orderJson, Order item,
      Function(bool, String?) onPaymentInitiated) async {
    setLoading = true;

    try {
      // Call the createOrder method in OrderService
      var orderResponse = await _orderService.createOrder(orderJson, item);

      if (orderResponse != null) {
        orderId = orderResponse.orderId;

        Map<String, dynamic>? paymentResult;
        // Payment method handling
        if (paymentMethod == 'Paystack') {
          paymentResult = await _handlePaystackPayment(item);
        } else if (paymentMethod == "Stripe") {
          paymentResult = await _handleStripePayment(item);
        } else {
          throw Exception("Unsupported payment method");
        }

        if (kIsWeb) {
// // // // // START_DISABLE
// if (paymentMethod == "Stripe") {
// processStripePaymentWeb(paymentResult);
// } else {
// final GetStorage box = GetStorage();
// String? email = box.read('userEmail');
// if (email == null) {
// throw Exception("User email not found in storage");
// }
// 
// String userEmail = jsonDecode(email);
// 
// processPaystackPaymentWeb(
// userEmail,
// double.parse(item.grandTotal),
// orderId,
// );
// }
// onPaymentInitiated(true, null);
// // // // // END_DISABLE
        } else {
          if (paymentMethod == "Stripe") {
            paymentUrl =
                processStripePaymentMobile(paymentResult, onPaymentInitiated);
          } else {
            paymentUrl =
                processPaystackPaymentMobile(paymentResult, onPaymentInitiated);
          }
        }
      } else {
        throw Exception("Order creation failed");
      }
    } catch (e, trace) {
      print("Order creation error: $e");
      print("Order creation error: $trace");
      onPaymentInitiated(false, null);
    } finally {
      setLoading = false;
    }
  }

  Future<Map<String, dynamic>> _handlePaystackPayment(Order item) async {
    // Construct Paystack payment request here...
    final GetStorage box = GetStorage();

    String email = box.read('userEmail');
    String userEmail = jsonDecode(email);

    PaymentPayStack paymentPayStack = PaymentPayStack(
      userId: item.userId,
      cartItemsPayStack: [
        CartItemPayStack(
          email: userEmail,
          orderId: orderId,
          price: item.grandTotal,
          quantity: 1,
          restaurantId: item.restaurantId,
        ),
      ],
    );

    String paymentDataPayStack = paymentPayStackToJson(paymentPayStack);
    return await _orderService.paymentFunction(paymentDataPayStack, 'Paystack');
  }

  Future<Map<String, dynamic>> _handleStripePayment(Order item) async {
    // Construct Stripe payment request here...
    Payment payment = Payment(
      userId: item.userId,
      cartItems: [
        CartItem(
          name: item.orderItems[0].foodTitle,
          foodId: item.orderItems[0].foodId,
          id: orderId,
          price: item.grandTotal,
          quantity: item.orderItems.length,
          restaurantId: item.restaurantId,
        ),
      ],
    );

    String paymentData = paymentToJson(payment);
    return await _orderService.paymentFunction(paymentData, 'Stripe');
  }

  Future<bool> updateConfirmation(String orderId) async {
    setLoading = true;
    try {
      bool success = await _orderService.updateConfirmation(orderId);
      return success;
    } catch (e) {
      print("Order confirmation error: $e");
      return false;
    } finally {
      setLoading = false;
    }
  }

  // Method to update loyalty points
  Future<bool> updateLoyaltyPoints(LoyaltyTransaction loyalty) async {
    setLoading = true; // Show loading indicator

    try {
      // Call the order service to handle the loyalty transaction
      bool success = await _orderService.loyaltyTransaction(loyalty.toJson());

      return success; // Return success or failure
    } catch (e) {
      print("Loyalty points update error: $e");
      return false; // Return false on error
    } finally {
      setLoading = false; // Hide loading indicator
    }
  }
}
