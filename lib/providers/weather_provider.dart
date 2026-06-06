import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  int _tempUnit = 0; // 0 = Celsius, 1 = Fahrenheit

  // Getters
  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get temperatureUnit => _tempUnit == 0 ? '°C' : '°F';

  Future<void> loadWeather(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simula delay de red de 1 segundo
      await Future.delayed(const Duration(seconds: 1));

      // Datos hardcodeados iniciales
      _weather = Weather(
        city: city,
        temperature: 24,
        condition: 'sunny',
        humidity: 65,
      );
    } catch (e) {
      _errorMessage = 'Error loading weather: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cambiar unidad de temperatura (°C <-> °F)
  void toggleTemperatureUnit() {
    _tempUnit = _tempUnit == 0 ? 1 : 0;
    notifyListeners();
  }

  /// Actualizar temperatura manualmente (con validación de seguridad)
  void updateTemperature(int newTemp) {
    if (_weather != null) {
      // Validación: Solo actualizar si el rango es seguro
      if (newTemp >= -50 && newTemp <= 60) {
        _weather = Weather(
          city: _weather!.city,
          temperature: newTemp,
          condition: _weather!.condition,
          humidity: _weather!.humidity,
        );
        notifyListeners();
      } else {
        debugPrint('Seguridad: Temperatura fuera de rango permitido.');
      }
    }
  }

  /// Método para actualizar el clima completo (útil para la SearchScreen)
  void updateWeather(String city, int temp, String condition) {
    _weather = Weather(
      city: city,
      temperature: temp,
      condition: condition,
      humidity: 60, // Valor por defecto para la simulación
    );
    notifyListeners();
  }
}
