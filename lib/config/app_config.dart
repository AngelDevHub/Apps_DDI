import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Clase que centraliza la configuración de la aplicación.
/// Lee las variables de entorno desde el archivo .env.
class AppConfig {
  // Getters que leen del .env en tiempo de ejecución
  static String get apiKey =>
      dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  
  static String get baseUrl =>
      dotenv.env['OPENWEATHER_BASE_URL'] ??
      'https://api.openweathermap.org/data/2.5/weather';

  // Validar que las variables estén cargadas correctamente
  static bool isConfigured() {
    return apiKey.isNotEmpty && baseUrl.isNotEmpty;
  }
}
