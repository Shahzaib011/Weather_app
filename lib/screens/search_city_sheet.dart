import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_services.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class SearchCitySheet extends StatefulWidget {
  final Function(WeatherModel) onCitySelected;

  const SearchCitySheet({super.key, required this.onCitySelected});

  @override
  State<SearchCitySheet> createState() => _SearchCitySheetState();
}

class _SearchCitySheetState extends State<SearchCitySheet> {
  final TextEditingController _controller = TextEditingController();

  bool isLoading = false;
  String? error;
  List<String> suggestions = [];

  Future<void> _onTextChanged(String value) async {
    if (value.trim().isEmpty) {
      setState(() => suggestions = []);
      return;
    }

    try {
      final results = await WeatherService.searchCities(value.trim());
      setState(() => suggestions = results);
    } catch (_) {}
  }

  Future<void> _selectCity(String city) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final weather = await WeatherService.fetchWeather(city);
      widget.onCitySelected(weather);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            onChanged: _onTextChanged,
            decoration: InputDecoration(
              hintText: "Search city",
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.grey.shade800,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          if (isLoading) const LoadingWidget(),
          if (error != null)
            CustomErrorWidget(message: error!, onRetry: () {}),

          Expanded(
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final city = suggestions[index];
                return ListTile(
                  title: Text(
                    city,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => _selectCity(city),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
