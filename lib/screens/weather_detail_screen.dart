import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../widgets/weather_card.dart';

class WeatherDetailScreen extends StatelessWidget {
  final WeatherModel weather;
  final VoidCallback? onSave;

  const WeatherDetailScreen({
    super.key,
    required this.weather,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(weather.city),
        actions: [
          if (onSave != null)
            IconButton(
              icon: const Icon(Icons.bookmark_add),
              onPressed: () {
                onSave!();
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            WeatherCard(weather: weather),
            const SizedBox(height: 20),
            _infoRow("Feels Like", "${weather.feelsLikeC}°C"),
            _infoRow("Humidity", "${weather.humidity}%"),
            _infoRow("Wind", "${weather.windKph} km/h"),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
