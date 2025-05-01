import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
    final String userId;
    final List<OrderItems> orderItems;
    final String orderTotal;
    final String restaurantAddress;
    final List<double> restaurantCoords;
    final List<double> recipientCoords;
    final String deliveryFee;
    final String grandTotal;
    final String deliveryAddress;
    final String paymentMethod;
    final String restaurantId;
    bool? promotion;
    double? promotionPrice;

    Order({
        required this.userId,
        required this.orderItems,
        required this.orderTotal,
        required this.restaurantAddress,
        required this.restaurantCoords,
        required this.recipientCoords,
        required this.deliveryFee,
        required this.grandTotal,
        required this.deliveryAddress,
        required this.paymentMethod,
        required this.restaurantId,

    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        userId: json["userId"],
        orderItems: List<OrderItems>.from(json["orderItems"].map((x) => OrderItems.fromJson(x))),
        orderTotal: json["orderTotal"],
        restaurantAddress: json["restaurantAddress"],
        restaurantCoords: List<double>.from(json["restaurantCoords"].map((x) => x?.toDouble())),
        recipientCoords: List<double>.from(json["recipientCoords"].map((x) => x?.toDouble())),
        deliveryFee: json["deliveryFee"],
        grandTotal: json["grandTotal"],
        deliveryAddress: json["deliveryAddress"],
        paymentMethod: json["paymentMethod"],
        restaurantId: json["restaurantId"],

    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "orderTotal": orderTotal,
        "restaurantAddress": restaurantAddress,
        "restaurantCoords": List<dynamic>.from(restaurantCoords.map((x) => x)),
        "recipientCoords": List<dynamic>.from(recipientCoords.map((x) => x)),
        "deliveryFee": deliveryFee,
        "grandTotal": grandTotal,
        "deliveryAddress": deliveryAddress,
        "paymentMethod": paymentMethod,
        "restaurantId": restaurantId,

    };
}

class OrderItem {
    final String foodId;
    final List<String> additives;
    final String quantity;
    final String price;
    final String instructions;
    final String unitPrice;
    OrderItem({
        required this.foodId,
        required this.additives,
        required this.quantity,
        required this.price,
        required this.instructions,
        required this.unitPrice,
    });

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        foodId: json["foodId"],
        additives: List<String>.from(json["additives"].map((x) => x)),
        quantity: json["quantity"],
        price: json["price"],
        instructions: json["instructions"],
        unitPrice: json["price"]
    );

    Map<String, dynamic> toJson() => {
        "foodId": foodId,
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "quantity": quantity,
        "price": price,
        "instructions": instructions,
        "unitPrice":unitPrice
    };
}

class OrderItems {
    final String foodId;
    final List<String> additives;
    final String quantity;
    final String price;
    final String foodImageUrl;
    final String foodTitle;
    final String instructions;
    final String restaurantId;
    final String restaurantAddress;
    final String cartItemId;
    final String restaurantImageUrl;
    final String restaurantTitle;
    final String restaurantTime;
    final double distance;
    final List<double> restaurantCoords;
    bool? promotion;
    double? promotionPrice;

    OrderItems({
        required this.foodId,
        required this.additives,
        required this.quantity,
        required this.foodImageUrl,
        required this.foodTitle,
        required this.price,
        required this.instructions,
        required this.cartItemId,
        required this.restaurantAddress,
        required this.restaurantId,
        required this.restaurantCoords,
        required this.restaurantImageUrl,
        required this.restaurantTitle,
        required this.restaurantTime,
        required this.distance,
        this.promotion,
        this.promotionPrice
    });

    factory OrderItems.fromJson(Map<String, dynamic> json) => OrderItems(
        foodId: json["foodId"],
        additives: List<String>.from(json["additives"].map((x) => x)),
        quantity: json["quantity"],
        foodImageUrl: json["foodImageUrl"],
        foodTitle: json["foodTitle"],
        cartItemId: json["cartItemId"],
        price: json["price"],
        instructions: json["instructions"],
        restaurantId: json["restaurantId"],
        restaurantAddress: json["restaurantAddress"],
        restaurantCoords: List<double>.from(
            json["restaurantCoords"].map((x) => x?.toDouble())),
        restaurantImageUrl: json["restaurantImageUrl"],
        restaurantTitle: json["restaurantTitle"],
        restaurantTime: json["restaurantTime"],
        distance: json["distance"],
        promotion: json['promotion'],
        promotionPrice: json['promotionPrice'].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "foodId": foodId,
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "quantity": quantity,
        "foodImageUrl": foodImageUrl,
        "foodTitle": foodTitle,
        "cartItemId": cartItemId,
        "price": price,
        "instructions": instructions,
        "restaurantId": restaurantId,
        "restaurantAddress": restaurantAddress,
        "restaurantCoords": List<dynamic>.from(restaurantCoords.map((x) => x)),
        "restaurantImageUrl": restaurantImageUrl,
        "restaurantTitle": restaurantTitle,
        "restaurantTime": restaurantTime,
        "distance": distance,
        "promotion":promotion,
        "promotionPrice":promotionPrice,
    };
}

