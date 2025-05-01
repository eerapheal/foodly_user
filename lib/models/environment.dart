import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static Future<void> loadEnv() async {
    String fileName;

    if (kIsWeb) {
      // For web builds
      fileName = kReleaseMode ? 'assets/.env.production' : 'assets/.env.development';
    } else {
      // For native builds
      fileName = kReleaseMode ? '.env.production' : '.env.development';
    }

    // Load the appropriate .env file
    await dotenv.load(fileName: fileName);
  }

  static String get googleApiKey {
    return dotenv.env['GOOGLE_API_KEY'] ?? 'API_KEY not found';
  }

  static String get googleApiKey2 {
    return dotenv.env['GOOGLE_API_KEY2'] ?? 'API_KEY not found';
  }

  static String get appBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'API_BASE_URL not found';
  }

  static String get paymentUrl {
    return dotenv.env['PAYMENT_URL'] ?? 'PAYMENT_URL not found';
  }
}
