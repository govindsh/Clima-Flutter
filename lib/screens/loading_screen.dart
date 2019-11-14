import 'package:flutter/material.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:clima/screens/nointernet_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:clima/services/here_weather.dart';
import 'package:geolocator/geolocator.dart';
import 'nolocation_screen.dart';

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

    var weatherData;
    var sevenDayWeatherData;
    var hourlyData;

    // Check for location services is enabled
    print("Checking if location services are enabled");

    GeolocationStatus isLocationEnabled = await Geolocator().checkGeolocationPermissionStatus(
      locationPermission: GeolocationPermission.locationWhenInUse,
    );

    print(isLocationEnabled);

    if (isLocationEnabled != GeolocationStatus.denied) {
      // Check for internet connection
      var connectivityResult = await (Connectivity().checkConnectivity());
      print(connectivityResult);
      if (connectivityResult == ConnectivityResult.none) {
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return NoInternetScreen();
        }));
      } else {
        weatherDataMap = await WeatherModel().getlocationWeather();

        weatherData = weatherDataMap['weatherData'];
        print("Weather data - $weatherData");

        hourlyData = weatherDataMap['hourlyData'];
        print("Hourly data - $hourlyData");

        sevenDayWeatherData = await HereWeatherModel()
            .getSevenDayLocationWeather();
        print('7 day here forecast - $sevenDayWeatherData');

        if (hourlyData == 400 || weatherData == 400 || sevenDayWeatherData == 400) {
          print('Got bad request, check location services - $isLocationEnabled');
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return NoLocationScreen();
          }));
        } else {
          print('In else block location status - $isLocationEnabled');
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return LocationScreen(
              locationWeather: weatherData,
              locationHourWeather: hourlyData,
              sevenDayWeather: sevenDayWeatherData,
            );
          }));

        }
      }
    } else {
      weatherData = 400;
      sevenDayWeatherData = 400;
      hourlyData = 400;
      Navigator.push(context, new MaterialPageRoute(builder: (context) {
        return NoLocationScreen();
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
