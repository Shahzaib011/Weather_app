import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class LocalStorageService {
  static const String _key = 'saved_cities';

  static Future<void> saveCities(List<WeatherModel> cities) async {
    final prefs = await SharedPreferences.getInstance();
    final data = cities.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, data);
  }

  static Future<List<WeatherModel>> loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];

    return data
        .map((e) => WeatherModel.fromLocalJson(jsonDecode(e)))
        .toList();
  }
}
