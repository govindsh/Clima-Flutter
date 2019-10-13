import 'package:clima/services/networking.dart';

const weatherHereAppId = 'NOlGuU6KMkvPBBcq0Dzc';
const weatherHereAppCode = 'bhOEbYe7vZLrlugLB0Hpeg';

const weatherHereURL = 'https://weather.api.here.com/weather/1.0/report.json?'
    'app_id=$weatherHereAppId&app_code=$weatherHereAppCode';

class HereWeatherModel {
  Future<dynamic> getSevenDayCityWeather(String cityName) async {
    var url = '$weatherHereURL&product=forecast_7days_simple&name=$cityName';

    print('7 day weather url for $cityName - $url');
    NetworkHelper networkHelper = NetworkHelper(url);

    var sevenDayWeather = await networkHelper.getData();
    print(sevenDayWeather);

    checkAPIResponse(sevenDayWeather);
    return sevenDayWeather;
  }

  Future<dynamic> getSevenDayLocationWeather() async {
    await location.getCurrentLocation();

    var url = '$weatherHereURL&product=forecast_7days_simple&'
        'latitude=${location.latitude}&longitude=${location.longitude}';

    NetworkHelper networkHelper = NetworkHelper(url);

    print(url);

    var sevenDayWeatherData = await networkHelper.getData();

    print(sevenDayWeatherData);

    checkAPIResponse(sevenDayWeatherData);
    return sevenDayWeatherData;
  }

  dynamic checkAPIResponse(var response) {
    if (response is int) {
      if (response == 404) {
        print("Here Weather - Data not found");
        return null;
      } else if (response == 400) {
        print("Here Weather - Bad request, check URL");
        return null;
      }
    } else if (response != null) {
      return response;
    }
  }
}
