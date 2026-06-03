import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climate App',
      debugShowCheckedModeBanner: false, // Quita la pestaña de debug molesta
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlue,
          brightness: Brightness.dark, // Un toque oscuro moderno para el clima
        ),
        useMaterial3: true,
      ),
      home: const ClimateHomePage(),
    );
  }
}

class ClimateHomePage extends StatefulWidget {
  const ClimateHomePage({super.key});

  @override
  State<ClimateHomePage> createState() => _ClimateHomePageState();
}

class _ClimateHomePageState extends State<ClimateHomePage> {
  // Variables simuladas para el estado del clima
  String _temperature = "24°C";
  String _condition = "Soleado";
  IconData _weatherIcon = Icons.wb_sunny_rounded;
  bool _isLoading = false;

  // Función para simular la actualización del clima
  void _refreshWeather() async {
    setState(() {
      _isLoading = true;
    });

    // Simulamos una consulta a una API de 1.5 segundos
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _temperature = "19°C";
      _condition = "Luvioso";
      _weatherIcon = Icons.thunderstorm_rounded;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Climate App ☁️'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Muestra carga si está buscando datos
            : Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono del Clima Grande
              Icon(
                _weatherIcon,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              // Temperatura
              Text(
                _temperature,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Condición (Soleado/Lluvioso)
              Text(
                _condition,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              // Botón para actualizar
              FilledButton.icon(
                onPressed: _refreshWeather,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Actualizar Clima'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}