// Define an enum for the reason
enum TransactionReason {
  earn,    // For earning points
  redeem,  // For redeeming points
  other,   // Any other custom reasons, adjust as per your actual enum values
}

class LoyaltyTransaction {
  String userId;
  int points;
  String? orderId;  // Optional orderId
  TransactionReason reason;  // Enum field
  DateTime? expiresAt;  // Expiration date

  LoyaltyTransaction({
    required this.userId,
    required this.points,
    this.orderId,  // Optional field
    required this.reason,  // Enum field
    this.expiresAt,  // Expiration date field
  });

  // Factory method to create a LoyaltyTransaction from JSON
  factory LoyaltyTransaction.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransaction(
      userId: json['userId'],
      points: json['points'],
      orderId: json['orderId'],  // This will automatically handle null cases
      reason: _mapStringToReason(json['reason']),  // Convert string to enum
      expiresAt: DateTime.parse(json['expiresAt']),  // Parse the expiration date from JSON
    );
  }

  // Method to convert a LoyaltyTransaction object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'points': points,
      'orderId': orderId ?? '',  // Optional orderId, if null return an empty string
      'reason': _mapReasonToString(reason),  // Convert enum to string
      //'expirationDate': expirationDate.toIso8601String(),  // Convert DateTime to ISO string
    };
  }
  // Helper method to map a string to the TransactionReason enum
  static TransactionReason _mapStringToReason(String reasonString) {
    switch (reasonString) {
      case 'earn':
        return TransactionReason.earn;
      case 'redeem':
        return TransactionReason.redeem;
      default:
        return TransactionReason.other;
    }
  }

  // Helper method to map the TransactionReason enum to a string
  static String _mapReasonToString(TransactionReason reason) {
    switch (reason) {
      case TransactionReason.earn:
        return 'earn';
      case TransactionReason.redeem:
        return 'redeem';
      case TransactionReason.other:
      default:
        return 'other';  // Default case for unrecognized enums
    }
  }
}

class TotalPoints {
  final double totalPoints;
  TotalPoints({required this.totalPoints});

  // A factory method to parse JSON data into the model
  factory TotalPoints.fromJson(Map<String, dynamic> json) {
    return TotalPoints(
      totalPoints: json['totalPoints'].toDouble(),
    );
  }

  // A method to convert the model to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
    };
  }
}

