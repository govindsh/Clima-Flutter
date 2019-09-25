import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class CreditsScreen extends StatefulWidget {
  @override
  _CreditsScreenState createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weatherman Credits'),
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFFFD7272),
                Color(0xFF3B3B98),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Developed by Srikkanth Govindaraajan.',
                  style: kCreditScreenTextStyle),
              Text(
                'Weather data provided by OpenWeatherMap API.',
                style: kCreditScreenTextStyle,
              ),
              Text(
                'Location search powered by Algolia places autocomplete.',
                style: kCreditScreenTextStyle,
              ),
              Text(
                'App Icon made by Flat Icons from Flaticon',
                style: kCreditScreenTextStyle,
              ),
              Text(
                'Photo by Kundan Ramisetti on Unsplash',
                style: kCreditScreenTextStyle,
              ),
              Text(
                'illustration by Ouch.pics',
                style: kCreditScreenTextStyle,
              ),
            ],
          ),
        ),
    );
  }
}
