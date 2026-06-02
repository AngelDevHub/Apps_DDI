import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class ClimateAppInterfaces extends StatelessWidget {
  const ClimateAppInterfaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climate App - Interfaces',
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
