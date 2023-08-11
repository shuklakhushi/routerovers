import 'package:flutter/material.dart';

class GreetingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to My App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello! Welcome to my Flutter app.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Image.network(
              'assets/images/paris.jpg', //display the image
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/calculator'); //navigate to calculator page
              },
              child: Text('Open Calculator'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/weather'); //navigate to weather page
              },
              child: Text('Check Weather'),
            ),
            
          ],
        ),
      ),
    );
  }
}
