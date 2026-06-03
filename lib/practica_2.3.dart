import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
import 'screens/home_screen.dart';

/// Punto de entrada para la Práctica 2.3
void main() {
  runApp(
    // MultiProvider inicializa los gestores de estado en la cima del árbol de widgets.
    // Esto permite que cualquier pantalla acceda a la información del clima.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const Practica23App(),
    ),
  );
}

class Practica23App extends StatelessWidget {
  const Practica23App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climate App - Práctica 2.3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          brightness: Brightness.light,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
