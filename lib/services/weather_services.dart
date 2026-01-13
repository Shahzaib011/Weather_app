import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = '239a5b53ae64445588361309260201';
  static const String _baseUrl = 'http://api.weatherapi.com/v1/current.json';

  static Future<WeatherModel> fetchWeather(String city) async {
    final url = Uri.parse('$_baseUrl?key=$_apiKey&q=$city&aqi=no');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return WeatherModel(
        city: data['location']['name'] ?? '',
        tempC: (data['current']['temp_c'] ?? 0).toDouble(),
        condition: data['current']['condition']['text'] ?? '',
        icon: data['current']['condition']['icon'] ?? '',
        feelsLikeC: (data['current']['feelslike_c'] ?? 0).toDouble(),
        humidity: (data['current']['humidity'] ?? 0).toInt(),
        windKph: (data['current']['wind_kph'] ?? 0).toDouble(),
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }
  static Future<List<String>> searchCities(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
      'http://api.weatherapi.com/v1/search.json?key=$_apiKey&q=$query',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data
          .map<String>((city) => city['name'].toString())
          .toSet()
          .toList();
    } else {
      throw Exception('Failed to fetch city suggestions');
    }
  }

}
