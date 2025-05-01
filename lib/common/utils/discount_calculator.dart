// lib/utils/discount_calculator.dart


class DiscountCalculator {
  static const double pointToMoneyRate = 6.0;  // 1 point = 1/6 of currency unit
  static const double maxDiscountRate = 0.3;    // User can use a max of 30% of the total points/money

  // Method to calculate discount percentage
  static String calculateDiscountPercentage(double originalPrice, double promotionPrice) {
    if (originalPrice == 0 || promotionPrice == 0) {
      return "0% OFF";
    }

    // Calculate the percentage of discount
    double discountPercentage = (( promotionPrice) / originalPrice) * 100;

    // Return the formatted string with the percentage
    return "${discountPercentage.toStringAsFixed(0)}% OFF";
  }
 //the discounted price
  static double calculateDiscountedPrice(double originalPrice, double promotionPrice) {
    if (originalPrice == 0 || promotionPrice == 0) {
      return 0.0;
    }

    // Calculate the price
    double discountPrice = (originalPrice-promotionPrice);

    // Return the formatted string with the price
    return discountPrice;
  }


// Function to convert points to money
  double convertPointsToMoney(double points) {
    return points / pointToMoneyRate;
  }

// Function to calculate the redeemable amount
  double calculateRedeemableAmount(double points, double totalPrice) {
    // Convert points to money
    double redeemableAmount = convertPointsToMoney(points);

    // Calculate the maximum discount the user can redeem
    double maxRedeemable = totalPrice * maxDiscountRate;
    double finalAmount = redeemableAmount > maxRedeemable ? maxRedeemable : redeemableAmount;

    // Allow the user to redeem the lesser of their redeemable amount or the max redeemable amount
    return finalAmount;
  }
}
