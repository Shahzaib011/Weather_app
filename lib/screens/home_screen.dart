import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_services.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherModel? weather;
  bool isLoading = false;
  String? errorMessage;
  final TextEditingController _cityController = TextEditingController(text: "London");

  @override
  void initState() {
    super.initState();
    _fetchWeather(_cityController.text);
  }

  Future<void> _fetchWeather(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await WeatherService.fetchWeather(city);
      setState(() {
        weather = data;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _searchCity() {
    final city = _cityController.text.trim();
    if (city.isNotEmpty) {
      _fetchWeather(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // City input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: "City",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _searchCity,
                  child: const Text("Search"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Loading/Error/Weather
            Expanded(
              child: Center(
                child: isLoading
                    ? const LoadingWidget()
                    : errorMessage != null
                    ? CustomErrorWidget(message: errorMessage!, onRetry: () {  },)
                    : weather != null
                    ? WeatherCard(weather: weather!)
                    : const Text("Enter a city to get weather"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
