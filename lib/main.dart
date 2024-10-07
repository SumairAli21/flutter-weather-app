import 'package:flutter/material.dart';
import 'package:weatherapp/screen.dart/splch_screen.dart';
import 'package:weatherapp/screen.dart/weather_screen.dart';

void main() {
  runApp(Weather());
}

class Weather extends StatelessWidget {
  const Weather({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: MysplachScreen(),
    );
  }
}
