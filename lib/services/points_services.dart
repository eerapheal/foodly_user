
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/models/loyalty_transaction.dart';


import 'api_services.dart';

class PointsServices extends ApiService{

  // Fetch points for a specific user
  Future<List<LoyaltyTransaction>?> getUserPoints(String userId) async {
    var url = Uri.parse('${Environment.appBaseUrl}/api/points/$userId');
    var response = await makeHttpRequest('GET', url, headers: getAuthHeaders());

    if (response['status'] == 200 && response['data'] != null) {

      // Check if 'data' is a list before proceeding
      if (response['data']['data'] is List) {
        var transactionsList = response['data']['data'] as List;

        // Map each item in the list to LoyaltyTransaction
        var transactions = transactionsList
            .map((transactionJson) => LoyaltyTransaction.fromJson(transactionJson))
            .toList();

        return transactions;

      } else {
        print('Unexpected format: nested data is not a list');
        return null;
      }
    } else {
      print('Failed to fetch user points: ${response['status']}');
      return null;
    }
  }

  // Fetch points for a specific user
  Future<TotalPoints?> getUserTotalPoints(String userId) async {
    var url = Uri.parse('${Environment.appBaseUrl}/api/points/totalPoints/$userId');
    var response = await makeHttpRequest('GET', url, headers: getAuthHeaders());

    if (response['status'] == 200 && response['data'] != null) {

      // Check if 'data' contains 'totalPoints' and if it's a valid number
      if (response['data']['totalPoints'] != null && response['data']['totalPoints'] is num) {
        return TotalPoints.fromJson(response['data']);  // Return the total points wrapped in a TotalPoints object
      } else {
        print('Unexpected format: totalPoints not found or invalid');
        return null;
      }
    } else {
      print('Failed to fetch user points: ${response['status']}');
      return null;
    }
  }
}