import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../widgets/narrow_weather_tile.dart';
import 'search_city_sheet.dart';
import 'weather_detail_screen.dart';
import '../services/local_stroage_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<WeatherModel> _savedCities = [];

  void _openSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SearchCitySheet(
        onCitySelected: (WeatherModel weather) {
          Navigator.pop(context); // close bottom sheet

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WeatherDetailScreen(
                weather: weather,
                onSave: () async {
                  if (!_savedCities.any((w) => w.city == weather.city)) {
                    setState(() {
                      _savedCities.add(weather);
                    });
                    await LocalStorageService.saveCities(_savedCities);
                  }
                },

              ),
            ),
          );
        },
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _loadSavedCities();
  }

  Future<void> _loadSavedCities() async {
    final cities = await LocalStorageService.loadCities();
    setState(() {
      _savedCities.addAll(cities);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _openSearchSheet,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: SafeArea(
        child: _savedCities.isEmpty
            ? const Center(
          child: Text(
            "No saved cities",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _savedCities.length,
          itemBuilder: (context, index) {
            final weather = _savedCities[index];

            return Dismissible(
              key: Key(weather.city),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) async {
                setState(() {
                  _savedCities.removeAt(index);
                });
                await LocalStorageService.saveCities(_savedCities);
              },
              child: NarrowWeatherTile(weather: weather),
            );
          },
        )

      ),
    );
  }
}
