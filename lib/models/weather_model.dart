class WeatherModel {
  final String city;
  final double tempC;
  final String condition;
  final String icon;
  final double feelsLikeC;
  final int humidity;
  final double windKph;

  WeatherModel({
    required this.city,
    required this.tempC,
    required this.condition,
    required this.icon,
    required this.feelsLikeC,
    required this.humidity,
    required this.windKph,
  });
  String get iconUrl {
    if (icon.startsWith('http')) {
      return icon;
    }
    return 'https:$icon';
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['location']['name'] ?? '',
      tempC: (json['current']['temp_c'] ?? 0).toDouble(),
      condition: json['current']['condition']['text'] ?? '',
      icon: json['current']['condition']['icon'] ?? '',
      feelsLikeC: (json['current']['feelslike_c'] ?? 0).toDouble(),
      humidity: (json['current']['humidity'] ?? 0).toInt(),
      windKph: (json['current']['wind_kph'] ?? 0).toDouble(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'tempC': tempC,
      'condition': condition,
      'icon': icon,
      'feelsLikeC': feelsLikeC,
      'humidity': humidity,
      'windKph': windKph,
    };
  }

  factory WeatherModel.fromLocalJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['city'],
      tempC: (json['tempC']).toDouble(),
      condition: json['condition'],
      icon: json['icon'],
      feelsLikeC: (json['feelsLikeC']).toDouble(),
      humidity: json['humidity'],
      windKph: (json['windKph']).toDouble(),
    );
  }

}
