import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class ExtendedWeatherDetails extends StatelessWidget {
  String imageName;
  String detail;
  String weatherMetric;
  String weatherDescription;
  String altText;
  String unit;

  ExtendedWeatherDetails(
      {this.imageName,
      this.weatherMetric = 'unavailable',
      this.weatherDescription = '',
      this.detail,
      this.altText = '',
      this.unit = ''});

  // Reference API - https://developer.here.com/documentation/weather/topics/resource-type-weather-items.html

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'images/$imageName.png',
          scale: 1.0,
        ),
        SizedBox(
          width: 10.0,
        ),
        detail != 'Air Quality'
            ?
//            Detail is not air quality
            (weatherMetric != '*'
//        Weather metric has some value
                ? Text(
                    '$detail : $weatherMetric $unit $weatherDescription',
                    style: kExtendedWeatherDetailsStyle,
                  )
                : Text(
//          Weather metric has no value
                    '$detail : $altText',
                    style: kExtendedWeatherDetailsStyle,
                  ))
            :
            // Detail is about air quality
            weatherMetric != ''
                ? Text(
                    '$detail : $weatherMetric',
                    style: kExtendedWeatherDetailsStyle,
                  )
                : Text(
                    '$detail : $altText',
                    style: kExtendedWeatherDetailsStyle,
                  )
      ],
    );
  }
}
