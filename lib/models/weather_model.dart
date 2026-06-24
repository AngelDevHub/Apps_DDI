/// Modelo que representa los datos climáticos.
/// Actualizado para la Práctica 2.5 (API Real).
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

  /// Factory para deserialización segura de la respuesta de OpenWeatherMap
  factory Weather.fromJson(Map<String, dynamic> json) {
    // Validar campos obligatorios antes de parsear
    if (!json.containsKey('main') || !json.containsKey('weather')) {
      throw const FormatException('Respuesta API incompleta');
    }
    
    if ((json['weather'] as List).isEmpty) {
      throw const FormatException('Sin datos de clima');
    }

    final temp = json['main']['temp'];
    // Validación de tipo: Asegurar que la temperatura sea un número
    if (temp is! num) {
      throw const FormatException('Temperatura inválida');
    }

    return Weather(
      city: json['name'] ?? 'Desconocido',
      temperature: temp.toInt(),
      condition: json['weather'][0]['main'] ?? 'Desconocido',
      description: json['weather'][0]['description'] ?? '',
      humidity: (json['main']['humidity'] ?? 0) as int,
      windSpeed: ((json['wind']?['speed']) ?? 0).toDouble(),
    );
  }

  /// Convertir Weather a JSON (útil para persistencia local)
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
