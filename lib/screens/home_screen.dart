import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/weather_icon.dart';
import '../widgets/custom_button.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_utils.dart';
import 'search_screen.dart';

/// Pantalla Principal (Dashboard)
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Actual'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      // Consumer permite que el widget se redibuje automáticamente 
      // cada vez que el WeatherProvider llama a notifyListeners()
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          final weather = weatherProvider.weather;
          
          return OrientationBuilder(
            builder: (context, orientation) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: orientation == Orientation.portrait
                      ? _buildPortrait(context, weather)
                      : _buildLandscape(context, weather),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Diseño optimizado para orientación vertical
  Widget _buildPortrait(BuildContext context, dynamic weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        _buildHeader(context, weather),
        const SizedBox(height: 60),
        _buildWeatherInfo(context),
        const SizedBox(height: 60),
        _buildAction(context),
      ],
    );
  }

  /// Diseño optimizado para orientación horizontal (lado a lado)
  Widget _buildLandscape(BuildContext context, dynamic weather) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _buildHeader(context, weather),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWeatherInfo(context),
              const SizedBox(height: 32),
              _buildAction(context),
            ],
          ),
        ),
      ],
    );
  }

  /// Encabezado con Ciudad e Icono dinámico basado en el estado
  Widget _buildHeader(BuildContext context, dynamic weather) {
    return Column(
      children: [
        Text(
          weather.city,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 16),
        WeatherIcon(condition: weather.condition, size: 120),
        const SizedBox(height: 16),
        Text(
          // Uso de función pura para formatear la temperatura
          formatTemperature(weather.temp, weather.unit),
          style: TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: -2,
          ),
        ),
      ],
    );
  }

  /// Información secundaria (Humedad/Viento)
  Widget _buildWeatherInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(context, Icons.water_drop_outlined, 'Humedad', '65%'),
          Container(
            height: 40,
            width: 1,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
          _buildDetailItem(context, Icons.air_rounded, 'Viento', '12 km/h'),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Sección de botones de acción e interacción con el Provider
  Widget _buildAction(BuildContext context) {
    return Column(
      children: [
        // Llama a toggleUnit para cambiar unidades globalmente
        CustomButton(
          text: 'Cambiar Unidad',
          color: Colors.orange,
          onPressed: () {
            Provider.of<WeatherProvider>(context, listen: false).toggleUnit();
          },
        ),
        const SizedBox(height: 16),
        // Función de prueba para simular cambios de estado
        CustomButton(
          text: 'Simular Clima Aleatorio',
          color: Colors.blueGrey,
          onPressed: () {
            final provider = Provider.of<WeatherProvider>(context, listen: false);
            provider.updateWeather(
              provider.weather.city,
              (15 + (DateTime.now().second % 20)).toDouble(),
              provider.weather.condition,
            );
          },
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Buscar Ciudades',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
        ),
      ],
    );
  }
}
