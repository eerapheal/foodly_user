import 'dart:convert';

DistanceTimeModel distanceTimeFromJson(String str) => DistanceTimeModel.fromJson(json.decode(str));


class DistanceTimeModel {
    final double price;
    final double distance;
    final double time;

    DistanceTimeModel({
        required this.price,
        required this.distance,
        required this.time,
    });

    factory DistanceTimeModel.fromJson(Map<String, dynamic> json) => DistanceTimeModel(
        price: json["price"]?.toDouble(),
        distance: json["distance"]?.toDouble(),
        time: json["time"]?.toDouble(),
    );
}
