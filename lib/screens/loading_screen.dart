import 'package:flutter/material.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    print("Getting location...");
    super.initState();
    getLocationData();
  }

  void getLocationData() async {

    var weatherDataMap = Map();

    weatherDataMap = await WeatherModel().getlocationWeather();

    var weatherData = weatherDataMap['weatherData'];
    print("Weather data - $weatherData");

    var hourlyData = weatherDataMap['hourlyData'];
    print("Hourly data - $hourlyData");

    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return LocationScreen(locationWeather: weatherData,locationHourWeather: hourlyData,);
    }));

  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SpinKitHourGlass(
              color: Colors.red.shade500,
              size: 100.0,
            ),
          ),
          SizedBox(height: 10.0,),
          Text('Getting location...'),
        ],
      ),
    );
  }
}
