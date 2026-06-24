 /// Modelo que representa los datos climáticos de una ciudad.
/// Se utiliza para centralizar la información que fluye a través del Provider.
class Weather {
  final String city;      // Nombre de la ciudad
  final double temp;      // Valor numérico de la temperatura
  final String condition; // Condición climática (sunny, cloudy, etc.)
  final String unit;      // Unidad de medida (°C o °F)

  Weather({
    required this.city,
    required this.temp,
    required this.condition,
    required this.unit,
  });
}
