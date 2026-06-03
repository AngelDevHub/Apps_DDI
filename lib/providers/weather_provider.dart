import 'package:flutter/material.dart';
import '../models/weather.dart';

/// Gestor de estado para la información del clima.
/// Utiliza ChangeNotifier para notificar a la UI cuando los datos cambian.
class WeatherProvider with ChangeNotifier {
  // Estado inicial de la aplicación
  Weather _weather = Weather(
    city: 'Santiago de Querétaro',
    temp: 24.0,
    condition: 'sunny',
    unit: '°C',
  );

  /// Getter para obtener el estado actual del clima.
  Weather get weather => _weather;

  /// Actualiza los datos del clima con validaciones de seguridad.
  /// Previene el almacenamiento de datos malformados o fuera de rango.
  void updateWeather(String newCity, double newTemp, String newCondition) {
    // CRITERIO DE SEGURIDAD: Validar datos antes de almacenar
    
    // 1. Validar nombre de ciudad (No vacío ni nulo)
    if (newCity.trim().isEmpty) {
      debugPrint('SEGURIDAD: El nombre de la ciudad no puede estar vacío.');
      return; 
    }

    // 2. Validar rango de temperatura (-60°C a 60°C) para evitar datos erróneos
    if (newTemp < -60 || newTemp > 60) {
      debugPrint('SEGURIDAD: Temperatura $newTemp°C fuera de rango permitido (-60 a 60).');
      return;
    }

    // Si las validaciones pasan, actualizamos el estado
    _weather = Weather(
      city: newCity.trim(),
      temp: newTemp,
      condition: newCondition,
      unit: _weather.unit,
    );

    // Notificar a todos los widgets que están escuchando (Consumer/Provider.of)
    notifyListeners();
  }

  /// Cambia la unidad de medida (°C <-> °F) y realiza la conversión matemática.
  void toggleUnit() {
    String newUnit = _weather.unit == '°C' ? '°F' : '°C';
    double newTemp = newUnit == '°F' 
        ? (_weather.temp * 9/5) + 32 
        : (_weather.temp - 32) * 5/9;
        
    _weather = Weather(
      city: _weather.city,
      temp: double.parse(newTemp.toStringAsFixed(1)),
      condition: _weather.condition,
      unit: newUnit,
    );
    
    notifyListeners();
  }
}
