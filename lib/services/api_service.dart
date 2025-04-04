import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/car_model.dart';

class ApiService {
  final String baseUrl = "https://carros-electricos.wiremockapi.cloud";

  Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return token;
    } else {
      return null;
    }
  }

  Future<List<Car>?> getCars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return null;

    final response = await http.get(
      Uri.parse("$baseUrl/carros"),
      headers: {"Authorization": token},
    );

    if (response.statusCode == 200) {
      List<dynamic> carsJson = jsonDecode(response.body);
      return carsJson.map((json) => Car.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
