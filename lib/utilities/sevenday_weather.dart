import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class SevenDayWeatherCard extends StatelessWidget {
  final String date;
  final String imageName;
  final int highTemperature;
  final int lowTemperature;
  final String dayName;

  SevenDayWeatherCard(
      {@required this.date,
      @required this.imageName,
      @required this.highTemperature,
      @required this.lowTemperature,
      @required this.dayName});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//            FittedBox(
//              child: Text(
//                '$date',
//                style: kshadowTextStyle,
//              ),
//            ),
            FittedBox(
              child: Text(
                '$dayName',
                style: kshadowTextStyle,
              ),
            ),
            Image.network(imageName, scale: 1.5,),
            FittedBox(
              child: Text('High - $highTemperature°C', style: kshadowTextStyle),
            ),
            FittedBox(
              child: Text('Low - $lowTemperature°C', style: kshadowTextStyle),
            )
          ],
        ),
      ),
    );
  }
}
