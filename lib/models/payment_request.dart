import 'dart:convert';

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

PaymentPayStack paymentPayStackFromJson(String str) => PaymentPayStack.fromJson(json.decode(str));

String paymentPayStackToJson(PaymentPayStack data) => json.encode(data.toJson());

class Payment {
    final String userId;
    final List<CartItem> cartItems;

    Payment({
        required this.userId,
        required this.cartItems,
    });

    factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        userId: json["userId"],
        cartItems: List<CartItem>.from(json["cartItems"].map((x) => CartItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "cartItems": List<dynamic>.from(cartItems.map((x) => x.toJson())),
    };
}
class PaymentPayStack {
    final String userId;
    final List<CartItemPayStack> cartItemsPayStack;

    PaymentPayStack({
        required this.userId,
        required this.cartItemsPayStack,
    });

    factory PaymentPayStack.fromJson(Map<String, dynamic> json) => PaymentPayStack(
        userId: json["userId"],
        cartItemsPayStack: List<CartItemPayStack>.from(json["cartItemsPayStack"].map((x) => CartItemPayStack.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "cartItemsPayStack": List<dynamic>.from(cartItemsPayStack.map((x) => x.toJson())),
    };
}


class CartItemPayStack {
    final String email;
    final String orderId;
    final String price;
    final int quantity;
    final String restaurantId;

    CartItemPayStack({
        required this.email,
        required this.orderId,
        required this.price,
        required this.quantity,
        required this.restaurantId,
    });

    factory CartItemPayStack.fromJson(Map<String, dynamic> json) => CartItemPayStack(
        email: json["email"],
        orderId: json["orderId"],
        price: json["price"],
        quantity: json["quantity"],
        restaurantId: json["restaurantId"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "orderId": orderId,
        "price": price,
        "quantity": quantity,
        "restaurantId": restaurantId,
    };
}

class CartItem {
    final String name;
    final String id;
    final String foodId;
    final String price;
    final int quantity;
    final String restaurantId;

    CartItem({
        required this.name,
        required this.id,
        required this.foodId,
        required this.price,
        required this.quantity,
        required this.restaurantId,
    });

    factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        name: json["name"],
        id: json["id"],
        foodId:json['foodId'],
        price: json["price"],
        quantity: json["quantity"],
        restaurantId: json["restaurantId"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "foodId":foodId,
        "price": price,
        "quantity": quantity,
        "restaurantId": restaurantId,
    };
}
