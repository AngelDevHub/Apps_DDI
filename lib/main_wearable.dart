import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
import 'widgets/weather_icon.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const WearableApp(),
    ),
  );
}

class WearableApp extends StatelessWidget {
  const WearableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climate Wear',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const WearHomeScreen(),
    );
  }
}

class WearHomeScreen extends StatefulWidget {
  const WearHomeScreen({super.key});

  @override
  State<WearHomeScreen> createState() => _WearHomeScreenState();
}

class _WearHomeScreenState extends State<WearHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Carga inicial automática
    Future.microtask(() =>
        Provider.of<WeatherProvider>(context, listen: false).loadWeather());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent),
            );
          }

          final weather = provider.weather;
          if (weather == null) {
            return const Center(
              child: Text('Sin datos', style: TextStyle(fontSize: 10)),
            );
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ciudad pequeña arriba
                Text(
                  weather.city.split(' ').first,
                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                
                // Icono central
                WeatherIcon(condition: weather.condition, size: 45),
                
                const SizedBox(height: 2),
                
                // Temperatura Grande
                Text(
                  '${weather.temperature}${provider.temperatureUnit}',
                  style: const TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Botón de acción rápido (circular y pequeño)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSmallButton(
                      Icons.refresh, 
                      () => provider.loadWeather()
                    ),
                    const SizedBox(width: 8),
                    _buildSmallButton(
                      Icons.swap_horiz, 
                      () => provider.toggleTemperatureUnit()
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSmallButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: Colors.blueAccent),
      ),
    );
  }
}
