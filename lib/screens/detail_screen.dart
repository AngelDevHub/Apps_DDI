import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/temperature_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/weather_icon.dart';
import '../providers/weather_provider.dart';
/*
class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> forecast = const [
    {'day': 'Lun', 'temp': '24°C', 'cond': 'sunny'},
    {'day': 'Mar', 'temp': '26°C', 'cond': 'sunny'},
    {'day': 'Mié', 'temp': '20°C', 'cond': 'rainy'},
    {'day': 'Jue', 'temp': '25°C', 'cond': 'cloudy'},
    {'day': 'Vie', 'temp': '28°C', 'cond': 'sunny'},
  ];

  @override
  Widget build(BuildContext context) {
    // ACCEDER AL PROVIDER PARA EL NOMBRE DE LA CIUDAD
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.weather;

    if (weather == null) {
      return const Scaffold(body: Center(child: Text('No hay datos seleccionados')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${weather.city} - 5 Días'),
        elevation: 0,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Expanded(
                    child: orientation == Orientation.portrait
                        ? _buildList()
                        : _buildGrid(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Volver',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: forecast.length,
      itemBuilder: (context, index) {
        return TemperatureCard(
          title: forecast[index]['day']!,
          temperature: forecast[index]['temp']!,
          subtitle: 'Pronóstico diario',
          trailing: WeatherIcon(
            condition: forecast[index]['cond']!,
            size: 32,
          ),
        );
      },
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: forecast.length,
      itemBuilder: (context, index) {
        return TemperatureCard(
          title: forecast[index]['day']!,
          temperature: forecast[index]['temp']!,
          trailing: WeatherIcon(
            condition: forecast[index]['cond']!,
            size: 24,
          ),
        );
      },
    );
  }
}
*/