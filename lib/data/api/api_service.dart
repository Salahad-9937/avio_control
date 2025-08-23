import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiService {
  static const String baseUrl = 'http://192.168.4.1';
  static const int timeoutSeconds = 2;

  Future<Map<String, dynamic>> fetchPressure() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/data')).timeout(Duration(seconds: timeoutSeconds));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Сервер вернул код: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }
}