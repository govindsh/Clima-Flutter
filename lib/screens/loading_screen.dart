import 'package:flutter/material.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:clima/screens/nointernet_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:clima/services/here_weather.dart';

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

    // Check for internet connection
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Navigator.push(context, new MaterialPageRoute(builder: (context) {
        return NoInternetScreen();
      }));
    } else {
      weatherDataMap = await WeatherModel().getlocationWeather();

      var weatherData = weatherDataMap['weatherData'];
      print("Weather data - $weatherData");

      var hourlyData = weatherDataMap['hourlyData'];
      print("Hourly data - $hourlyData");

      var sevenDayWeatherData = await HereWeatherModel().getSevenDayLocationWeather();
      print('7 day here forecast - $sevenDayWeatherData');

      Navigator.push(context, new MaterialPageRoute(builder: (context) {
        return LocationScreen(
          locationWeather: weatherData,
          locationHourWeather: hourlyData,
          sevenDayWeather: sevenDayWeatherData,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 'weatherman',
            child: Image(
              image: AssetImage('images/weatherman.png'),
              height: 120.0,
            ),
          ),
          Center(
            child: SpinKitHourGlass(
              color: Colors.red.shade500,
              size: 50.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text('Getting location...'),
        ],
      ),
    );
  }
}
