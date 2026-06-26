import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../config/app_config.dart';

class WeatherService {
  static const Duration _timeout = Duration(seconds: 10);

  Future<Weather> getWeather(String city) async {
    if (city.trim().isEmpty) {
      throw ArgumentError('La ciudad no puede estar vacía');
    }

    final cleanCity = city.trim().replaceAll(RegExp(r'[^\w\s]'), '');

    if (!AppConfig.isConfigured()) {
      throw Exception('Configuración incompleta');
    }

    final uri = Uri.parse(
      '${AppConfig.baseUrl}'
      '?q=$cleanCity'
      '&appid=${AppConfig.apiKey}'
      '&units=metric'
      '&lang=es',
    );

    try {
      final response = await http.get(uri).timeout(_timeout);

      switch (response.statusCode) {
        case 200:
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          return Weather.fromJson(json);
        case 401:
          throw Exception('Acceso no autorizado');
        case 404:
          throw Exception('Ciudad no encontrada');
        case 429:
          throw Exception('Límite de peticiones excedido');
        default:
          throw Exception('Error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Sin conexión');
    } on TimeoutException {
      throw Exception('Tiempo agotado');
    } on FormatException catch (e) {
      throw Exception('Error de formato: $e');
    }
  }

  Future<List<Weather>> getWeatherForCities(List<String> cities) async {
    final futures = cities.map((c) => getWeather(c));
    return Future.wait(futures);
  }
}
