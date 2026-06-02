import 'package:flutter/material.dart';
import '../widgets/weather_icon.dart';
import '../widgets/custom_button.dart';
import 'search_screen.dart';

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
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: orientation == Orientation.portrait
                  ? _buildPortrait(context)
                  : _buildLandscape(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        _buildHeader(context),
        const SizedBox(height: 60),
        _buildWeatherInfo(context),
        const SizedBox(height: 60),
        _buildAction(context),
      ],
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _buildHeader(context),
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

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Santiago de Querétaro',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 16),
        const WeatherIcon(condition: 'sunny', size: 120),
        const SizedBox(height: 16),
        Text(
          '24°C',
          style: TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: -2,
          ),
        ),
      ],
    );
  }

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

  Widget _buildAction(BuildContext context) {
    return CustomButton(
      text: 'Buscar Ciudades',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
    );
  }
}
