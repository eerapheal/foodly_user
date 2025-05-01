import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final GetStorage box = GetStorage();

  // Generalized HTTP request method
  Future<Map<String, dynamic>> makeHttpRequest(
      String method,
      Uri url,
      {Map<String, String>? headers,
        dynamic body}) async {

    http.Response response;

    try {
      if (method == 'POST') {
        response = await http.post(url, headers: headers, body: body);
      } else if (method == 'PUT') {
        response = await http.put(url, headers: headers, body: body);
      } else if (method == 'GET') {
        response = await http.get(url, headers: headers);
      } else {
        throw Exception("Unsupported HTTP method");
      }

      // Parse the response
      var jsonResponse = jsonDecode(response.body);
      return {
        'status': response.statusCode,
        'data': jsonResponse,
      };
    } catch (e) {
      print('HTTP request failed: $e');
      return {
        'status': 500,
        'error': e.toString(),
      };
    }
  }

  // Helper method to get the authorization header
  Map<String, String> getAuthHeaders() {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }
}
