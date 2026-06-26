class Weather {
  final String city;
  final int temperature;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('main') || !json.containsKey('weather')) {
      throw const FormatException('Data error');
    }
    
    if ((json['weather'] as List).isEmpty) {
      throw const FormatException('Empty data');
    }

    final temp = json['main']['temp'];
    if (temp is! num) {
      throw const FormatException('Invalid data');
    }

    return Weather(
      city: json['name'] ?? 'Unknown',
      temperature: temp.toInt(),
      condition: json['weather'][0]['main'] ?? 'Unknown',
      description: json['weather'][0]['description'] ?? '',
      humidity: (json['main']['humidity'] ?? 0) as int,
      windSpeed: ((json['wind']?['speed']) ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'temperature': temperature,
    'condition': condition,
    'description': description,
    'humidity': humidity,
    'windSpeed': windSpeed,
  };

  @override
  String toString() =>
      'Weather($city: ${temperature}C, $condition, $humidity%, ${windSpeed}m/s)';
}
