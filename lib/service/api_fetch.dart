import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api/";
  static String? token="1|UiHaS53kaRMDpJDA4SKf7HqPfghUa7JPVeJ4TqXa033fbc92";
  static void setToken(String userToken) {
    token = userToken;
  }
  static Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };
  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl + endpoint),
        headers: headers,
      );
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      print("GET ERROR: $e");
      return {"result": false, "message": "Connection error"};
    }
  }

  static Future<dynamic> post(String endpoint, Map data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: headers,
        body: jsonEncode(data),
      );
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      return {"result": false, "message": "Connection error"};
    }
  }
  static Future<dynamic> delete(String endpoint, int id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl$endpoint/$id"),
        headers: headers,
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      return {"result": false, "message": "Connection error"};
    }
  }
  static Future<dynamic> patch(String endpoint, Map data) async {
  try {
    final response = await http.patch(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(data),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    return jsonDecode(response.body);
  } catch (e) {
    print("PATCH ERROR: $e");
    return {"result": false, "message": "Connection error"};
  }
}

}
