import 'package:flutter/material.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/services/networking.dart';
import 'package:intl/intl.dart';
import 'package:clima/utilities/weather_card.dart';
import 'package:clima/utilities/hourly_weather.dart';
import 'package:clima/utilities/sevenday_weather.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:clima/screens/nointernet_screen.dart';
import 'dart:core';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:clima/components/sun_card.dart';
import 'package:clima/services/here_weather.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/components/extended_weather_details.dart';


class LocationScreen extends StatefulWidget {
  LocationScreen(
      {this.locationWeather, this.locationHourWeather, this.sevenDayWeather});

  final locationWeather;
  final locationHourWeather;
  final sevenDayWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;
  WeatherModel weatherModel = WeatherModel();
  HereWeatherModel hereWeatherModel = HereWeatherModel();
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
  String maxTemp;
  String minTemp;
  String date;
  String dayName;
  String windCondition;
  String chanceOfRain;
  String precipitationDescription;
  String feelsLikeTemp;
  String rainFall;
  String snowFall;
  String airDescription;
  String altDate;

  List hourlyConditions = List();
  List hourlyTemperatures = List();
  List hourlyTimes = List();
  List<Widget> hourlyWeatherWidgetList = List();
  List<Widget> sevenDayWeatherWidgetList = List();
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

    updateUI(widget.locationWeather, widget.locationHourWeather,
        widget.sevenDayWeather);
  }

  void updateUI(
      dynamic weatherData, dynamic hourlyData, dynamic sevenDayWeatherData) {
    setState(() {
      //Set weather information

      if (weatherData == null ||
          hourlyData == null ||
          sevenDayWeatherData == null) {
        hourlyWeatherWidgetList = [];
        temperature = 0;
        weatherIcon = 'images/error.png';
        message = 'Unable to get weather data';
        cityName = 'Please try another city.';
        description = 'Weather data unavailable';
        condition = 700;
        humidity = 0;
        maxTemp = '0';
        minTemp = '0';
        sunriseTime = 0;
        sunsetTime = 0;
        wind = 0;

        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd EEEE');
        altDate = formatter.format(now);

        return;
      } else if (weatherData == 400 ||
          hourlyData == 400 ||
          sevenDayWeatherData == 400) {
        hourlyWeatherWidgetList = [];
        temperature = 0;
        weatherIcon = 'images/error.png';
        message = 'Please turn on location services';
        cityName = 'Try again';
        description = 'Could not find location';
        condition = 700;
        humidity = 0;
        maxTemp = '0';
        minTemp = '0';
        sunriseTime = 0;
        sunsetTime = 0;
        wind = 0;

        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd EEEE');
        altDate = formatter.format(now);

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

        for (int i = 0; i < 9; i++) {
          temp = hourlyData['list'][i]['main']['temp'];
          temperature = temp.toInt();
          int condition = hourlyData['list'][i]['weather'][0]['id'];

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
      }

      // Get here weather details
      date = sevenDayWeatherData['dailyForecasts']['forecastLocation']
              ['forecast'][0]['utcTime']
          .toString()
          .split('T')[0];

      dayName = sevenDayWeatherData['dailyForecasts']['forecastLocation']
          ['forecast'][0]['weekday'];

      chanceOfRain = sevenDayWeatherData['dailyForecasts']['forecastLocation']
          ['forecast'][0]['precipitationProbability'];

      windCondition = sevenDayWeatherData['dailyForecasts']['forecastLocation']
          ['forecast'][0]['beaufortDescription'];

      feelsLikeTemp = sevenDayWeatherData['dailyForecasts']['forecastLocation']
          ['forecast'][0]['comfort'];

      snowFall = sevenDayWeatherData['dailyForecasts']['forecastLocation']
          ['forecast'][0]['snowFall'];

      precipitationDescription = sevenDayWeatherData['dailyForecasts']
          ['forecastLocation']['forecast'][0]['precipitationDesc'];

      rainFall = sevenDayWeatherData['dailyForecasts']['forecastLocation']
          ['forecast'][0]['rainFall'];

      airDescription = sevenDayWeatherData['dailyForecasts']['forecastLocation']
          ['forecast'][0]['airDescription'];

      maxTemp = sevenDayWeatherData['dailyForecasts']['forecastLocation']
          ['forecast'][0]['highTemperature'];

      minTemp = sevenDayWeatherData['dailyForecasts']['forecastLocation']
          ['forecast'][0]['lowTemperature'];

      for (int i = 0; i < 7; i++) {
        var imageName = sevenDayWeatherData['dailyForecasts']
            ['forecastLocation']['forecast'][i]['iconLink'];

        var date = sevenDayWeatherData['dailyForecasts']['forecastLocation']
                ['forecast'][i]['utcTime']
            .toString()
            .split('T')[0];

        var dayName = sevenDayWeatherData['dailyForecasts']['forecastLocation']
            ['forecast'][i]['weekday'];

        double highTemp = double.parse(sevenDayWeatherData['dailyForecasts']
            ['forecastLocation']['forecast'][i]['highTemperature']);

        double lowTemp = double.parse(sevenDayWeatherData['dailyForecasts']
            ['forecastLocation']['forecast'][i]['lowTemperature']);

        sevenDayWeatherWidgetList.add(SevenDayWeatherCard(
          date: date,
          imageName: imageName,
          highTemperature: highTemp.toInt(),
          lowTemperature: lowTemp.toInt(),
          dayName: dayName,
        ));
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
          child: ListView(
            scrollDirection: Axis.vertical,
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

                        var sevenDayForecast =
                            await hereWeatherModel.getSevenDayLocationWeather();

                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) {
                          return LocationScreen(
                            locationWeather: weatherDataMap['weatherData'],
                            locationHourWeather: weatherDataMap['hourlyData'],
                            sevenDayWeather: sevenDayForecast,
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
                      Icons.location_on,
                      color: Colors.black54,
                      size: 40.0,
                    ),
                  ),
                  Hero(
                    tag: 'weatherman',
                    child: Image(
                      image: AssetImage('images/weatherman.png'),
                      height: 40.0,
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

                        var sevenDayForecast = await hereWeatherModel
                            .getSevenDayCityWeather(typedName);
                        print(sevenDayForecast);

                        updateUI(weatherDataMap['weatherData'],
                            weatherDataMap['hourlyData'], sevenDayForecast);
                      }

                      // Stop displaying the spinner
                      setState(() {
                        showSpinner = false;
                      });
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.black54,
                      size: 40.0,
                    ),
                  ),
                ],
              ),

              date != null ?
              Text(
                '$date - $dayName',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DG',
                  fontSize: 30.0,
                  color: Colors.black,
                ),
              ) :
              Text(
                altDate,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DG',
                  fontSize: 30.0,
                  color: Colors.black,
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Center(
                        child: Text(
                          '${toBeginningOfSentenceCase(description)} - $cityName - $temperature°C',
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
              SizedBox(
                height: 20.0,
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

              SizedBox(
                height: 20.0,
              ),

              // Display forecast for next 24 hours

              Text(
                '24 hour forecast',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DG',
                  fontSize: 30.0,
                  color: Colors.black,
                ),
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

              SizedBox(
                height: 20.0,
              ),

              // Display Extended Weather conditions

              Text(
                'Weather Conditions today',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DG',
                  fontSize: 30.0,
                  color: Colors.black,
                ),
              ),

              // Display humidity, wind, max and min temp

              Row(
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
                        value: '${double.parse(maxTemp).toInt()} °C',
                        imageName: 'images/high-temperature.png'),
                  ),
                  Expanded(
                    child: WeatherCard(
                        keyType: 'Min Temp',
                        value: '${double.parse(minTemp).toInt()} °C',
                        imageName: 'images/low-temperature.png'),
                  ),
                  Expanded(
                    child: WeatherCard(
                        keyType: 'Wind',
                        value: '${wind.toInt()} km/h',
                        imageName: 'images/windy.png'),
                  ),
                ],
              ),

              SizedBox(
                height: 20.0,
              ),

              Card(
                color: Color(0xFFF8EFBA),
                child: Container(
                  width: 100,
                  child: Column(
                    children: <Widget>[
                      ExtendedWeatherDetails(
                        imageName: 'rain_icon',
                        detail: 'Chance of Rain',
                        weatherDescription: precipitationDescription,
                        weatherMetric: chanceOfRain,
                        unit: '%',
                        altText: '0% No Rain expected today',
                      ),
                      ExtendedWeatherDetails(
                        imageName: 'rain_icon',
                        detail: 'Rainfall',
                        weatherMetric: rainFall,
                        unit: 'cm',
                        altText: '0 cm',
                      ),
                      ExtendedWeatherDetails(
                        imageName: 'wind_icon',
                        detail: 'Wind',
                        weatherMetric: windCondition,
                      ),
                      ExtendedWeatherDetails(
                        imageName: 'snow_icon',
                        detail: 'Snowfall',
                        weatherMetric: snowFall,
                        weatherDescription: ' cm',
                        altText: '0 cm',
                      ),

                      ExtendedWeatherDetails(
                        imageName: 'air-quality',
                        detail: 'Air Quality',
                        weatherDescription: airDescription,
                        altText: 'unavailable',
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 20.0,
              ),

              // Display 7 day weather forecast
              Text(
                '7 Day forecast',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DG',
                  fontSize: 30.0,
                  color: Colors.black,
                ),
              ),

              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 40.0,
                  maxHeight: 100.0,
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: sevenDayWeatherWidgetList,
                ),
              ),

              SizedBox(
                height: 40.0,
              ),

              SizedBox(
                height: 20.0,
              ),

              // Show Sunrise and Sunset times
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SunCard(
                    timestamp: sunriseTime,
                    isSunRise: true,
                  ),
                  SunCard(
                    timestamp: sunsetTime,
                    isSunRise: false,
                  ),
                ],
              ),

              SizedBox(
                height: 20.0,
              ),

              Text('*All times are displayed in local timezone.', style: kExtendedWeatherDetailsStyle,)
            ],
          ),
        ),
      ),
    );
  }
}
