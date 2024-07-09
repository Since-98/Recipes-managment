import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_url.dart'; // Ensure this points to your actual base URL

class AuthenticationServices {
  static const String _baseUrl = 'http://127.0.0.1:8000/api';
  static String _bearerToken = '';

  static void setBearerToken(String bearerToken) {
    _bearerToken = bearerToken;
  }

  // api/register/
  static Future<bool> register(String email, String password, String name) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      }),
    );

    return response.statusCode == 200;
  }

  // api/login/
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(response.body);
      _bearerToken = result['access_token'];
    }

    return response.statusCode == 200;
  }

  // api/logout/
  static Future<bool> logout() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_bearerToken',
      },
    );

    return response.statusCode == 200;
  }

  static String getBearerToken() {
    return _bearerToken;
  }
}
