import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/services/networking.dart';
import 'package:intl/intl.dart';
import 'package:clima/utilities/weather_card.dart';
import 'package:clima/utilities/hourly_weather.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:clima/screens/nointernet_screen.dart';
import 'dart:core';
import 'credits_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:clima/components/sun_card.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather, this.locationHourWeather});

  final locationWeather;
  final locationHourWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;
  WeatherModel weatherModel = WeatherModel();
  int temperature;
  String weatherIcon;
  String cityName;
  String message;
  String description;
  var humidity;
  var condition;
  var wind;
  int sunriseTime;
  int sunsetTime;
  double maxTemp;
  double minTemp;

  List maxTemperatures = List();
  List minTemperatures = List();
  List hourlyConditions = List();
  List hourlyTemperatures = List();
  List hourlyTimes = List();
  List<Widget> hourlyWeatherWidgetList = List();
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // Start the animation
    controller.forward();

    // Add animation listener
    controller.addListener(() {
      setState(() {});
    });

    updateUI(widget.locationWeather, widget.locationHourWeather);
  }

  void updateUI(dynamic weatherData, dynamic hourlyData) {
    setState(() {
      //Set weather information

      if (weatherData == null || hourlyData == null) {
        hourlyWeatherWidgetList = [];
        temperature = 0;
        weatherIcon = 'images/error.png';
        message = 'Unable to get weather data';
        cityName = 'Please try another city.';
        description = 'Weather data unavailable';
        condition = 700;
        humidity = 0;
        maxTemp = 0;
        minTemp = 0;
        sunriseTime = 0;
        sunsetTime = 0;
        wind = 0;
        return;
      } else if (weatherData == 400 || hourlyData == 400) {
        hourlyWeatherWidgetList = [];
        temperature = 0;
        weatherIcon = 'images/error.png';
        message = 'Please turn on location services';
        cityName = 'Try again';
        description = 'Could not find location';
        condition = 700;
        humidity = 0;
        maxTemp = 0;
        minTemp = 0;
        sunriseTime = 0;
        sunsetTime = 0;
        wind = 0;
      } else if (weatherData == 'No Internet Connection') {
        Navigator.pushReplacementNamed(context, '/NoInternetScreen');
      } else {
        condition = weatherData['weather'][0]['id'];
        print("Weather condition code - $condition");
        weatherIcon = weatherModel.getWeatherIcon(condition);
        print("Weather Icon - $weatherIcon");

        dynamic temp = weatherData['main']['temp'];
        temperature = temp.toInt();

        message = weatherModel.getMessage(temperature);
        cityName = weatherData['name'];
        humidity = weatherData['main']['humidity'];
        wind = weatherData['wind']['speed'];
        sunriseTime = weatherData['sys']['sunrise'];
        sunsetTime = weatherData['sys']['sunset'];
        print('Sun rise = $sunriseTime');
        print('Sun set time = $sunsetTime');
        description = weatherData['weather'][0]['description'];
        print(description);

        // Set hourly Weather information for the next 8 hours
        hourlyWeatherWidgetList = [];

        for (int i = 0; i < 8; i++) {
          temp = hourlyData['list'][i]['main']['temp'];
          temperature = temp.toInt();
          int condition = hourlyData['list'][i]['weather'][0]['id'];
          var temp_max = hourlyData['list'][i]['main']['temp_max'];
          var temp_min = hourlyData['list'][i]['main']['temp_min'];

          maxTemperatures.add(temp_max);
          minTemperatures.add(temp_min);

          var timestamp = hourlyData['list'][i]['dt'];

          var humanReadableTimestamp =
              DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000)
                  .toLocal();

          var format = new DateFormat.Md().add_jm();
          var hourFormat = format.format(humanReadableTimestamp);

          hourlyWeatherWidgetList.add(HourlyWeatherCard(
            time: (hourFormat).toString(),
            imageName: weatherModel.getWeatherIcon(condition),
            temperature: temperature.toString(),
          ));
        }
        minTemp = minTemperatures.reduce((curr, next) => curr < next ? curr: next);
        print(minTemp);
        maxTemp = maxTemperatures.reduce((curr, next) => curr > next ? curr: next);
        print(maxTemp);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: Container(
          color: weatherModel.getBackgroundColor(condition),
          constraints: BoxConstraints.expand(),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () async {
                        // Display Spinner to show Progress
                        setState(() {
                          showSpinner = true;
                        });
                        var weatherDataMap = Map();

                        // If internet connection is present, display weather data
                        if (await NetworkHelper.checkInternetConnection()) {
                          weatherDataMap =
                              await weatherModel.getlocationWeather();
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (context) {
                            return LocationScreen(
                              locationWeather: weatherDataMap['weatherData'],
                              locationHourWeather: weatherDataMap['hourlyData'],
                            );
                          }));
                        } else {
                          // Display no internet screen
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (context) {
                            return NoInternetScreen();
                          }));
                        }

                        // Stop displaying the spinner
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      child: Icon(
                        Icons.near_me,
                        color: Colors.black54,
                        size: 40.0,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (context) {
                            return CreditsScreen();
                          },
                        ));
                      },
                      child: Hero(
                        tag: 'weatherman',
                        child: Image(
                          image: AssetImage('images/weatherman.png'),
                          height: 40.0,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        // Display spinner to show progress before loading screen
                        setState(() {
                          showSpinner = true;
                        });

                        // Get the typed city name from the city screen
                        var typedName = await Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) {
                              return CityScreen();
                            },
                          ),
                        );

                        // Get weather data for city and display
                        if (typedName != null) {
                          var weatherDataMap = Map();
                          weatherDataMap =
                              await weatherModel.getCityWeather(typedName);
                          updateUI(weatherDataMap['weatherData'],
                              weatherDataMap['hourlyData']);
                        }

                        // Stop displaying the spinner
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      child: Icon(
                        Icons.location_city,
                        color: Colors.black54,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Center(
                          child: Text(
                            '${toBeginningOfSentenceCase(description)} - $cityName',
                            style: TextStyle(
                              fontFamily: 'DG',
                              fontSize: 30.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      '$weatherIcon',
                      height: controller.value * 100,
                    ),
                  ],
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 40.0,
                    maxHeight: 100.0,
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: hourlyWeatherWidgetList,
                  ),
                ),
                FittedBox(
                  child: Center(
                    child: Text(
                      "$cityName - $temperature°C",
                      textAlign: TextAlign.left,
                      style: kMessageTextStyle,
                    ),
                  ),
                ),
                // Show Sunrise and Sunset times
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          child: SunCard(
                        isSunRise: true,
                        timestamp: sunriseTime,
                      )),
                      Expanded(
                          child: SunCard(
                        isSunRise: false,
                        timestamp: sunsetTime,
                      )),
                    ],
                  ),
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: WeatherCard(
                            keyType: 'Humidity',
                            value: '$humidity %',
                            imageName: 'images/humidity.png'),
                      ),
                      Expanded(
                        child: WeatherCard(
                            keyType: 'Max Temp',
                            value: '${maxTemp.toInt()} °C',
                            imageName: 'images/high-temperature.png'),
                      ),
                      Expanded(
                        child: WeatherCard(
                            keyType: 'Min Temp',
                            value: '${minTemp.toInt()} °C',
                            imageName: 'images/low-temperature.png'),
                      ),
                      Expanded(
                        child: WeatherCard(
                            keyType: 'Wind',
                            value: '$wind km/h',
                            imageName: 'images/windy.png'),
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  child: Text(
                    '* Times are displayed in local time.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
