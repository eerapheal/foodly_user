import 'dart:convert';

import 'package:foodly_user/models/user_cart.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../models/order_item.dart';

class CartCheckoutController extends GetxController {
  final RxList<UserCart> _cartItems = <UserCart>[].obs;
  final RxList<String> _cartItemIds = <String>[].obs;
  final RxDouble _totalPrice = 0.0.obs;
  final RxList<OrderItems> _orderItems = <OrderItems>[].obs;

  final RxList<UserCart> cartObs = <UserCart>[].obs;

  double get totalPrice => _totalPrice.value;
  set setTotalPrice(price)=>_totalPrice.value=price;

  List<UserCart> get cartItems => _cartItems;
  List<String> get cartItemIds => _cartItemIds;
  List<OrderItems> get orderItems => _orderItems;

/*  RxBool _moreItems = false.obs;
  RxBool get moreItems=>_moreItems;*/


  RxList<String> _tempCartList=<String>[].obs;
  List<String> get tempCartList=>_tempCartList;
  //temp restaurant list to check the restaurants are same or not
  List<String> _restList=[];
  List<String> get restList=>_restList;
  //on the cart page, make sure select items from only one restaurant
  //added on 3.2.8
  bool setTempList(String item, String resId) {
    // Check if the temp cart list is empty
    if (_tempCartList.isEmpty) {
      _tempCartList.add(item);
      // Add the restaurant id if the list is empty
      _restList.add(resId);
      return true;

      // Return true indicating successful addition
    }

    // If the list already has an item, check if the new item matches the existing one
   if(_restList.contains(resId)){
     //the above condition means we already selected from the same restaurant
     if (_tempCartList.contains(item)) {
      //the above condition means we have already added the same food from the same restaurant
         if(_tempCartList.length==1){
           //means the same food from the same restaurant
           _restList.clear();
         }
         _tempCartList.remove(item);
       return true;  // Return true since the item already exists in the list
     }else{
       _tempCartList.add(item);
       return true;
     }
   }

    // If the item does not match, do not add and return false
    print("Item does not match the existing item in the list. Cannot add: $item");
    return false;
  }

  //to check if the restaurants are same or not
  //added 3.2.8
  bool checkUniqueResId(String id, String resId) {;
    return setTempList(id, resId);
  }


  void addCartItem(UserCart cartItem, {bool plusMinus=false}) {
    // Check if the cart item already exists
    if (_cartItemIds.contains(cartItem.id)) {
      if(!plusMinus) {
       // plusMinus=true means that delete buttons not presses
        //false = that means the delete button was pressed
        removeCartItem(cartItem.id);
      }
    } else {

      _cartItems.add(cartItem);
      _cartItemIds.add(cartItem.id);
      //eventually the cart items to place order
      _orderItems.add(_createOrderItem(cartItem));
    }

    calculateTotalPrice();
    update();
  }

  void removeCartItem(String itemId) {
    final int index = _cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _cartItems.removeAt(index);
      _cartItemIds.remove(itemId);
      print("removing items at ${itemId}");
      _orderItems.removeWhere((item) => item.cartItemId == itemId);
      update();
    }
  }

  void calculateTotalPrice() {

    _totalPrice.value =
        _cartItems.fold(0.0, (sum, item){
          return sum + (item.unitPrice*item.quantity);
        });

  }
  //this is for individual order items added in the cart
  OrderItems _createOrderItem(UserCart cartItem) {
    return OrderItems(
      foodId: cartItem.productId.id,
      cartItemId: cartItem.id,
      additives: cartItem.additives,
      quantity: cartItem.quantity.toString(),
      price: cartItem.totalPrice.toString(),
      instructions: cartItem.instructions,
      restaurantId: cartItem.productId.restaurant.id,
      restaurantAddress: cartItem.productId.restaurant.coords.address,
      restaurantCoords: [
        cartItem.productId.restaurant.coords.latitude,
        cartItem.productId.restaurant.coords.longitude,
      ],
      restaurantImageUrl: cartItem.productId.restaurant.imageUrl,
      restaurantTitle: cartItem.productId.restaurant.coords.title,
      restaurantTime: cartItem.productId.restaurant.time,
      distance: 0.0,
      foodImageUrl: cartItem.productId.imageUrl[0],
      foodTitle: cartItem.productId.title,
      promotion: cartItem.promotion,
      promotionPrice: cartItem.promotionPrice,
    );
  }

  clearCart(){
    //moreItems.value = false;
    setTotalPrice = 0.0;
    restList.clear();
    cartItems.clear();
    tempCartList.clear();
    orderItems.clear();
    cartObs.clear();
  }
}
