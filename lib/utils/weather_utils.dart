import 'package:flutter/material.dart';

/// Clase de utilidades estáticas para lógica de clima.
/// Sigue estrictamente la estructura solicitada por el profesor.
class WeatherUtils {
  
  // Convierte Celsius a Fahrenheit
  static double celsiusToFahrenheit(int celsius) {
    return (celsius * 9 / 5) + 32;
  }

  // Convierte Fahrenheit a Celsius
  static int fahrenheitToCelsius(double fahrenheit) {
    return ((fahrenheit - 32) * 5 / 9).toInt();
  }

  // Obtiene ícono (emoji o icono) según la condición climática
  static String getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return '☀️';
      case 'cloudy':
        return '☁️';
      case 'rainy':
        return '🌧️';
      case 'snowy':
        return '❄️';
      case 'windy':
        return '💨';
      default:
        return '❓';
    }
  }

  // Valida si la temperatura está en un rango real (-50 a 60)
  static bool isValidTemperature(int temp) {
    return temp >= -50 && temp <= 60;
  }

  // Función adicional para formatear texto (útil en UI)
  static String formatDisplay(int temp, String unit) {
    return '$temp$unit';
  }
}
