import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:geolocator/geolocator.dart';
import 'package:clima/services/here_weather.dart';
import 'dart:io' show Platform;

class NoLocationScreen extends StatefulWidget {
  @override
  _NoLocationScreenState createState() => _NoLocationScreenState();
}

class _NoLocationScreenState extends State<NoLocationScreen> {
  bool showSpinner = false;
  WeatherModel weatherModel = WeatherModel();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text('Enable location services'),
        ),
        body: Column(
          children: <Widget>[
            Image(
              image: AssetImage('images/searching.png'),
            ),
            RaisedButton(
              onPressed: () {
//                Platform.isIOS ? AppSettings.openLocationSettings() : AppSettings.openAppSettings();
                AppSettings.openAppSettings();
              },
              child: Text('Open Location Settings.'),
            ),
            RaisedButton(
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                var weatherDataMap = Map();
                var sevenDayWeatherData;

                // Check if location services is enabled

                GeolocationStatus isLocationEnabled = await Geolocator().checkGeolocationPermissionStatus(
                  locationPermission: GeolocationPermission.locationWhenInUse,
                );

                if (isLocationEnabled != GeolocationStatus.denied &&
                    isLocationEnabled != GeolocationStatus.unknown) {

                  // Get weather data
                  weatherDataMap = await weatherModel.getlocationWeather();
                  sevenDayWeatherData = await HereWeatherModel().getSevenDayLocationWeather();

                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) {
                    return LocationScreen(
                      locationWeather: weatherDataMap['weatherData'],
                      locationHourWeather: weatherDataMap['hourlyData'],
                      sevenDayWeather: sevenDayWeatherData,
                    );
                  }));
                } else {
                  // Location services is disabled or unknown
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) {
                        return NoLocationScreen();
                      }));
                }
                setState(() {
                  showSpinner = false;
                });
              },
              child: Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
