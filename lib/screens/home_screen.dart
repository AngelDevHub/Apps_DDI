import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/weather_icon.dart';
import '../widgets/custom_button.dart';
import '../providers/weather_provider.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Carga inicial requerida por el profesor
    Future.microtask(() =>
      Provider.of<WeatherProvider>(context, listen: false).loadWeather('Santiago de Querétaro')
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Actual'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }

          final weather = provider.weather;
          if (weather == null) {
            return const Center(child: Text('No hay datos disponibles'));
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  weather.city,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                
                // RECUPERADO: Tu icono animado/diseñado anterior
                WeatherIcon(condition: weather.condition, size: 120),
                
                const SizedBox(height: 24),
                Text(
                  '${weather.temperature}${provider.temperatureUnit}',
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -2,
                  ),
                ),
                
                const SizedBox(height: 40),
                _buildWeatherInfo(context, weather),
                
                const SizedBox(height: 60),
                CustomButton(
                  text: 'Cambiar Unidad',
                  color: Colors.orange,
                  onPressed: () => provider.toggleTemperatureUnit(),
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeatherInfo(BuildContext context, dynamic weather) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(Icons.water_drop_outlined, 'Humedad', '${weather.humidity}%'),
          Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.2)),
          _buildDetailItem(Icons.cloud_outlined, 'Estado', weather.condition),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
