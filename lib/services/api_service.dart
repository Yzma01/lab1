import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab1/models/user.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Error de servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  Future<User> getUserById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/$id'));

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error de servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }
}
