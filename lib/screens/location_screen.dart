import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:intl/intl.dart';
import 'package:clima/utilities/weather_card.dart';
import 'package:clima/utilities/hourly_weather.dart';
import 'package:clima/screens/city_screen.dart';
import 'dart:core';


class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather, this.locationHourWeather});

  final locationWeather;
  final locationHourWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  int temperature;
  String weatherIcon;
  String cityName;
  String message;
  String description;
  var humidity;
  var condition;
  var wind;

  List hourlyConditions = List();
  List hourlyTemperatures = List();
  List hourlyTimes = List();
  List<Widget> hourlyWeatherWidgetList = List();

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather, widget.locationHourWeather);
  }

  void updateUI(dynamic weatherData, dynamic hourlyData) {
    setState(() {
      //Set weather information

      if (weatherData == null || hourlyData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        message = 'Unable to get weather data';
        cityName = '';
        return;
      }
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
      description = weatherData['weather'][0]['description'];
      print(description);

      // Set hourly Weather information for the next 8 hours
      hourlyWeatherWidgetList = [];

      for (int i = 0; i < 4; i++) {
        temp = hourlyData['list'][i]['main']['temp'];
        temperature = temp.toInt();
        int condition = hourlyData['list'][i]['weather'][0]['id'];

        var timestamp = hourlyData['list'][i]['dt'];

        var humanReadableTimestamp = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()*1000);

        var format = new DateFormat.Md().add_jm();
        var hourFormat = format.format(humanReadableTimestamp);


        hourlyWeatherWidgetList.add(HourlyWeatherCard(
            time: (hourFormat).toString(),
            imageName: weatherModel.getWeatherIcon(condition),
            temperature: temperature.toString(),
        ));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      var weatherDataMap = Map();
                      weatherDataMap = await weatherModel.getlocationWeather();
                      updateUI(weatherDataMap['weatherData'],
                          weatherDataMap['hourlyData']);
                    },
                    child: Icon(
                      Icons.near_me,
                      color: Colors.black54,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        var weatherDataMap = Map();
                        weatherDataMap =
                            await weatherModel.getCityWeather(typedName);
                        updateUI(weatherDataMap['weatherData'],
                            weatherDataMap['hourlyData']);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      color: Colors.black54,
                      size: 50.0,
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
                          '$description in $cityName',
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
                  ),
                ],
              ),
              Center(
                child: Wrap(
                  children: hourlyWeatherWidgetList,
                ),
              ),
                  Center(
                    child: Text(
                      "$cityName - $temperature°C",
                      textAlign: TextAlign.left,
                      style: kMessageTextStyle,
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
                    )),
                    Expanded(
                        child: WeatherCard(
                      keyType: 'Wind',
                      value: '$wind km/h',
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
