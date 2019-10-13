import 'package:clima/services/networking.dart';
import 'package:flutter/material.dart';

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
      return Color(0xFFB4E1E5);
    } else if (condition >= 700 && condition < 800) {
      return Color(0xFFA9EDCE);
    } else if (condition >= 800 && condition <= 804) {
      return Color(0xFFF2AC7A);
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
      return 'images/sunny-128.png';
    } else if (condition <= 804) {
      return 'images/cloudy-128.png';
    } else {
      return 'images/puzzled.png';
    }
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
