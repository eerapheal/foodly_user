import 'dart:convert';

List<Food> foodFromJsonForRestaurant(String str)
=> List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));

List<Food> foodFromJson(dynamic json) {
    return List<Food>.from(json.map((item) => Food.fromJson(item)));
}

String foodToJson(List<Food> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Food {
    final String id;
    final String title;
    final List<String> foodTags;
    final List<String?> foodType;
    final String code;
    final bool isAvailable;
    final String restaurant;
    final double rating;
    final String ratingCount;
    final String description;
    final double price;
    final List<Additive> additives;
    final List<String> imageUrl;
    final int v;
    final String? category;
    final String time;
    bool? promotion;
    double? promotionPrice;

    Food({
        required this.id,
        required this.title,
        required this.foodTags,
        required this.foodType,
        required this.code,
        required this.isAvailable,
        required this.restaurant,
        required this.rating,
        required this.ratingCount,
        required this.description,
        required this.price,
        required this.additives,
        required this.imageUrl,
        required this.v,
        required this.category,
        required this.time,
        this.promotion,
        this.promotionPrice,
    });
    factory Food.fromJson(Map<String, dynamic> json) {

        try {
            double promoPrice=0.0;
            if(json["promotionPrice"]==null){
                json["promotionPrice"]=0.0;
            }
            return Food(
                id: json["_id"] ?? '',
                title: json["title"] ?? '',
                foodTags: List<String>.from(json["foodTags"]?.map((x) => x) ?? []),
                foodType: List<String?>.from(json["foodType"]?.map((x) => x) ?? []),
                code: json["code"] ?? '',
                isAvailable: json["isAvailable"] ?? false,
                restaurant: json["restaurant"]?.toString() ?? '', // Ensure conversion to string
                rating: json["rating"]?.toDouble() ?? 0.0, // Convert to double, default to 0.0 if null
                ratingCount: json["ratingCount"]?.toString() ?? '0', // Convert to string, default to '0'
                description: json["description"] ?? '',
                price: json["price"]?.toDouble() ?? 0.0, // Convert to double, default to 0.0 if null
                additives: List<Additive>.from(json["additives"]?.map((x) => Additive.fromJson(x)) ?? []),
                imageUrl: List<String>.from(json["imageUrl"]?.map((x) => x) ?? []),
                v: json["__v"] ?? 0,
                category: json["category"]?.toString() ?? '', // Ensure conversion to string
                time: json["time"] ?? '',
                promotion: json["promotion"]??false,
                promotionPrice: json["promotionPrice"]?.toDouble()??0.0,
            );
        } catch (e, trace) {
            print("Error parsing food item: $trace");
            throw Exception("Failed to parse Food JSON $e");
        }
    }




    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "foodTags": List<dynamic>.from(foodTags.map((x) => x)),
        "foodType": List<dynamic>.from(foodType.map((x) => x)),
        "code": code,
        "isAvailable": isAvailable,
        "restaurant": restaurant,
        "rating": rating,
        "ratingCount": ratingCount,
        "description": description,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x.toJson())),
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "__v": v,
        "category": category,
        "time": time,
    };
}

class Additive {
    final int id;
    final String title;
    final String price;

    Additive({
        required this.id,
        required this.title,
        required this.price,
    });

    factory Additive.fromJson(Map<String, dynamic> json) => Additive(
        id: json["id"],
        title: json["title"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
    };
}
