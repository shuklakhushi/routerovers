import 'package:flutter/material.dart';
import 'greeting_page.dart';
import 'calculator_page.dart';
import 'weather_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App with Tools',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => GreetingPage(),
        '/calculator': (context) => CalculatorPage(),
        '/weather': (context) => WeatherPage(),

        // Define routes for other pages here
      },
    );
  }
}
