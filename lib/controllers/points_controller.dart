import 'dart:convert';

import 'package:foodly_user/services/points_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../common/utils/discount_calculator.dart';
import '../models/loyalty_transaction.dart';
import 'order_controller.dart';

class PointsController extends GetxController {
  // Observable list for storing loyalty transactions
  var userPoints = <LoyaltyTransaction>[].obs;
  RxDouble userTotalPoints = 0.0.obs;
  final PointsServices _pointsServices = Get.find<PointsServices>();


  @override
  void onReady() {
    super.onReady();
    fetchUserPoints();
    // Fetch user points when the controller is ready

  }

  // Method to fetch points for a specific user
  // Fetch points from the service
  Future<void> fetchUserPoints() async {
    final box = GetStorage();
    final userId = jsonDecode(box.read("userId"));
    var fetchedPoints = await PointsServices().getUserPoints(userId);
    if (fetchedPoints != null && fetchedPoints.isNotEmpty) {
      userPoints.assignAll(fetchedPoints);  // Assign the fetched points to the observable list
    } else {
      userPoints.clear();  // Clear the list if no points are returned
    }
  }

  Future<void> fetchUserTotalPoints(String userId) async {
    var fetchedPoints = await PointsServices().getUserTotalPoints(userId);

    if (fetchedPoints != null) {
      userTotalPoints.value=fetchedPoints.totalPoints.toDouble(); // Assign the fetched points to the observable list
        var redeemableAmount=0.0;

        //based on points calculate redeemable points
        redeemableAmount = DiscountCalculator().calculateRedeemableAmount(
            userTotalPoints.value,
            Get.find<OrderController>().orderPrice
        );
        Get.find<OrderController>().redeemableAmount = redeemableAmount;

    } else {
      userTotalPoints.value=0.0;
    }

  }
}
