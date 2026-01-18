import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/weather_model.dart';
import '../widgets/narrow_weather_tile.dart';
import 'search_city_sheet.dart';
import 'weather_detail_screen.dart';
import '../services/local_stroage_services.dart';
import 'login_screen.dart';

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

  Future<void> _loadSavedCities() async {
    final cities = await LocalStorageService.loadCities();
    setState(() {
      _savedCities.addAll(cities);
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // soft Apple-like gray
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DrawerHeader(
                child: Text(
                  "Menu",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text("Logout"),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F7),
        elevation: 0,
        title: const Text(
          "Weather App",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF007AFF),
        onPressed: _openSearchSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: _savedCities.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.cloud_queue,
                  size: 80, color: Colors.black26),
              SizedBox(height: 16),
              Text(
                "No saved cities yet",
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(
                "Tap + to add your first city",
                style: TextStyle(color: Colors.black26),
              ),
            ],
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
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) async {
                setState(() {
                  _savedCities.removeAt(index);
                });
                await LocalStorageService.saveCities(_savedCities);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: NarrowWeatherTile(weather: weather),
              ),
            );
          },
        ),
      ),
    );
  }
}
