import 'package:flutter/material.dart';

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Weather Information',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            WeatherWidget(),
          ],
        ),
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String _weatherInfo = 'Sunny, 25°C'; //static value

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            Icons.wb_sunny,
            size: 80,
            color: Colors.orange,
          ),
          SizedBox(height: 20),
          Text(
            _weatherInfo,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement weather data fetching logic here
              setState(() {
                _weatherInfo = 'Cloudy, 20°C'; //static value
              });
            },
            child: Text('Refresh Weather'),
          ),
        ],
      ),
    );
  }
}
