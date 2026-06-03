import 'package:flutter/material.dart';

/// Funciones puras que no dependen del estado externo.
/// Facilitan la reutilización y las pruebas unitarias.

/// Formatea un valor numérico a un string con un decimal y su unidad.
/// Ejemplo: (24.0, "°C") -> "24.0°C"
String formatTemperature(double temp, String unit) {
  return '${temp.toStringAsFixed(1)}$unit';
}

/// Mapea un string de condición climática a un IconData específico.
/// Ayuda a centralizar la lógica visual del clima.
IconData getWeatherIcon(String condition) {
  switch (condition.toLowerCase()) {
    case 'sunny':
      return Icons.wb_sunny_rounded;
    case 'cloudy':
      return Icons.cloud_rounded;
    case 'rainy':
      return Icons.umbrella_rounded;
    case 'snowy':
      return Icons.ac_unit_rounded;
    case 'windy':
      return Icons.air_rounded;
    default:
      return Icons.help_outline_rounded;
  }
}
