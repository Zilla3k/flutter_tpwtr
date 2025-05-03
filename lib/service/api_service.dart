import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String _apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final url = Uri.parse(
      '$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric&lang=pt_br',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      debugPrint('Erro: ${response.statusCode}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchForecast(String city) async {
    final url = Uri.parse(
      '$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric&lang=pt_br',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      debugPrint('Erro: ${response.statusCode}');
      return null;
    }
  }
}
