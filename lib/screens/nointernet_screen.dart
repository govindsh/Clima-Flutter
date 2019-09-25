import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool showSpinner = false;
  WeatherModel weatherModel = WeatherModel();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('No internet connection'),
        ),
        body: Column(
          children: <Widget>[
            Image(
              image: AssetImage('images/no-connection.png'),
            ),
            RaisedButton(
              onPressed: () {
                AppSettings.openWIFISettings();
              },
              child: Text('Open Wifi Settings.'),
            ),
            RaisedButton(
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                var weatherDataMap = Map();
                if (await NetworkHelper.checkInternetConnection()) {
                  weatherDataMap = await weatherModel.getlocationWeather();
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) {
                    return LocationScreen(
                      locationWeather: weatherDataMap['weatherData'],
                      locationHourWeather: weatherDataMap['hourlyData'],
                    );
                  }));
                } else {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) {
                        return NoInternetScreen();
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
