import 'package:clima/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const appId = 'e236362ae503f219d27750b503a41f51';

const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';
const openWeatherMapForecastURL =
    'https://api.openweathermap.org/data/2.5/forecast/';



class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    var url = '$openWeatherMapURL?q=$cityName&appId=$appId&units=metric';

    NetworkHelper networkHelper = NetworkHelper(url);

    print("URL - $url");

    var weatherData;
    var weatherDataMap = Map();

    try {
      weatherData = await networkHelper.getData();
    } catch (SocketException) {
      weatherDataMap['weatherData'] = 'No Internet Connection';
      weatherDataMap['hourlyData'] = 'No Internet Connection';
      return weatherDataMap;
    }
      print(weatherData);

      var forecastUrl = '$openWeatherMapForecastURL?q=$cityName&appId=$appId&'
          'units=metric';

      NetworkHelper networkHelperHourly = NetworkHelper(forecastUrl);
      var hourlyData = await networkHelperHourly.getData();

    if (weatherData is int) {
      if (weatherData == 404) {
        print("No data found");
        return null;
      } else if (weatherData == 400) {
        print('Bad request');
        return null;
      }
    }

    if (weatherData != null && hourlyData != null) {
      weatherDataMap['weatherData'] = weatherData;
      weatherDataMap['hourlyData'] = hourlyData;
      return weatherDataMap;
    } else {
      if (weatherData == 404) {
        print("No data found");
        return null;
      }
    }
  }

  Future<dynamic> getlocationWeather() async {
    await location.getCurrentLocation();

    String url = '$openWeatherMapURL?lat='
        '${location.latitude}&lon=${location.longitude}&appid=$appId&units=metric';
    NetworkHelper networkHelper = NetworkHelper(url);

    var weatherDataMap = Map();

    var weatherData;
    try {
      weatherData = await networkHelper.getData();
    } catch (SocketException) {
      weatherDataMap['weatherData'] = 'No Internet Connection';
      weatherDataMap['hourlyData'] = 'No Internet Connection';
      return weatherDataMap;
    }

    var hourlyData =
        await getHourlyWeatherData(location.latitude, location.longitude);

    weatherDataMap['weatherData'] = weatherData;
    weatherDataMap['hourlyData'] = hourlyData;

    return weatherDataMap;
  }

  Future<dynamic> getHourlyWeatherData(
      double latitude, double longitude) async {
    var url = '$openWeatherMapForecastURL?lat=$latitude&lon=$longitude&appid='
        '$appId&units=metric';

    print("Hourly forecast url - $url");

    NetworkHelper networkHelper = NetworkHelper(url);
    var hourlyWeatherData = await networkHelper.getData();

    return hourlyWeatherData;
  }

  Color getBackgroundColor(int condition) {
    if (condition < 700) {
      if (int.parse(getTimeMarker()['hour']) > 6 && getTimeMarker()['timeOfDay'] == 'PM') {
        return Color(0xFF3498db);
      } else {
        return Color(0xFFB4E1E5);
      }
    } else if (condition >= 700 && condition < 800) {
      if (int.parse(getTimeMarker()['hour']) > 6 && getTimeMarker()['timeOfDay'] == 'PM') {
        return Color(0xFF74b9FF);
      } else {
        return Color(0xFFA9EDCE);
      }
    } else if (condition >= 800 && condition <= 804) {
      if (int.parse(getTimeMarker()['hour']) > 6 && getTimeMarker()['timeOfDay'] == 'PM') {
        return Color(0xFF0984E3);
      } else {
        return Color(0xFFF2AC7A);
      }
    }
  }

  String getWeatherIconForHourlyForecast(int condition, String time) {
    if (condition == 800) {
      var hour = time.split(' ')[1].split(':')[0];
      var image = '';
      if (int.parse(hour) > 6 && time.split(' ')[2] == 'PM' ) {
        image = 'images/night_clear_sky.png';
      } else {
        image = 'images/sunny-128.png';
      }
      return image;
    } else {
      return getWeatherIcon(condition);
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return 'images/thunderstorms-128.png';
    } else if (condition < 400) {
      return 'images/light-rain-128.png';
    } else if (condition < 600) {
      return 'images/showers-128.png';
    } else if (condition < 700) {
      return 'images/snow-128.png';
    } else if (condition < 800) {
      return 'images/overcast-128.png';
    } else if (condition == 800) {
      if (int.parse(getTimeMarker()['hour']) > 6 && getTimeMarker()['timeOfDay'] == 'PM') {
        return 'images/night_clear_sky.png';
      } else {
        return 'images/sunny-128.png';
      }
    } else if (condition <= 804) {
      return 'images/cloudy-128.png';
    } else {
      return 'images/puzzled.png';
    }
  }

  Map getTimeMarker() {
    var now = new DateTime.now();
    var formatter = new DateFormat('K:a');

    var hour = formatter.format(now).split(':')[0];
    var timeOfDay = formatter.format(now).split(':')[1];

    Map timeIdentifiers = new Map();
    timeIdentifiers['hour'] = hour;
    timeIdentifiers['timeOfDay'] = timeOfDay;
//    print(timeIdentifiers);
    return timeIdentifiers;
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }

  String getHumidityPercent(dynamic weatherData) {
    return weatherData['main']['humudity'];
  }
}
