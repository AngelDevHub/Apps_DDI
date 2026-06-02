import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String condition;
  final double? size;

  const WeatherIcon({
    Key? key,
    required this.condition,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (condition.toLowerCase()) {
      case 'sunny':
        iconData = Icons.wb_sunny_rounded;
        iconColor = Colors.orangeAccent;
        break;
      case 'cloudy':
        iconData = Icons.wb_cloudy_rounded;
        iconColor = Colors.grey;
        break;
      case 'rainy':
        iconData = Icons.umbrella_rounded;
        iconColor = Colors.blueAccent;
        break;
      default:
        iconData = Icons.wb_cloudy_rounded;
        iconColor = Colors.blueGrey;
    }

    return Icon(
      iconData,
      size: size ?? 80,
      color: iconColor,
    );
  }
}
