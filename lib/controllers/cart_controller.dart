import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodly_user/common/show_snack_bar.dart';
import 'package:foodly_user/controllers/check_out_controller.dart';
import 'package:foodly_user/models/api_error.dart';
import 'package:foodly_user/models/cart_response.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  final box = GetStorage();

  // Reactive state
  var _address = false.obs;
  var _deletingItemId = ''.obs; // To track the item being deleted
  get deletingItemId => _deletingItemId;
  // Getter
  bool get address => _address.value;

  // Setter
  set setAddress(bool newValue) {
    _address.value = newValue;
  }

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  RxBool _placeOrder = false.obs;
  RxBool get placeOrder =>_placeOrder;
  set setPlaceOrder(bool order)=>_placeOrder.value=order;

  void addToCart(String item) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    //setLoading = true;
    print("items are ${item}");

    _placeOrder.value=true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/cart');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: item,
      );

      if (response.statusCode == 201) {
       // setLoading = false;
        _placeOrder.value=false;
        CartResponse data = cartResponseFromJson(response.body);

        box.write("cart", jsonEncode(data.count));

        showCustomSnackBar("Product added successfully to cart",
          isError: false, title: "Success"
          );
      } else {
        var data = apiErrorFromJson(response.body);

        showCustomSnackBar("Failed to add address, please try again",
            title: "Errors"
        );
        _placeOrder.value=false;
      }
    } catch (e) {
     // setLoading = false;
      showCustomSnackBar("Failed to add address, please try again",
          title: "Errors"
      );
      _placeOrder.value=false;
    } finally {
     // setLoading = false;
      _placeOrder.value=false;
    }
  }


removeFormCart(String productId) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    _placeOrder.value=true;
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/cart/delete/$productId');
    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
      );

      if (response.statusCode == 200) {
        setLoading = false;

        CartResponse data = cartResponseFromJson(response.body);
        box.write("cart", jsonEncode(data.count));
        Get.find<CartCheckoutController>().removeCartItem(productId);
        Get.find<CartCheckoutController>().calculateTotalPrice();

        showCustomSnackBar("The product was removed from cart successfully",
            title: "Product removed"
        );
       // Get.offAll(() =>  MainScreen());
        _placeOrder.value=false;
      } else {
        var data = apiErrorFromJson(response.body);

        showCustomSnackBar("Failed to remove the item, please try again",
            title: "Errors"
        );
      }
    } catch (e) {
      setLoading = false;
      _placeOrder.value=false;
      showCustomSnackBar("Failed to remove the item, please try again",
          title: "Errors"
      );
    } finally {
      setLoading = false;
      _placeOrder.value=false;
    }
  }
}
