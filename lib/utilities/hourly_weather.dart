import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class HourlyWeatherCard extends StatelessWidget {
  final String time;
  final String imageName;
  final String temperature;

  HourlyWeatherCard(
      {@required this.time,
      @required this.imageName,
      @required this.temperature});

  bool checkMorning(String timestamp) {
    if(timestamp.contains('AM')) {
      return true;
    } else {
      return false;
    }
  }

  Color getTimeOfDayColor(String timestamp) {
    var temp = timestamp.split(" ")[1];
    var hour = temp.toString().split(":")[0];
    if(checkMorning(timestamp)) {
      if (int.parse(hour) < 6) {
        return Color(0xFF0984e3);
      } else if (int.parse(hour) > 6 && int.parse(hour) < 12) {
        return Color(0xFFF8EFBA);
      }
    } else {
      if (int.parse(hour) < 6) {
        return Color(0xFFF8EFBA);
      } else if (int.parse(hour) > 6 && int.parse(hour) < 12) {
        return Color(0xFF2C3A47);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getTimeOfDayColor(time),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FittedBox(
              child: Text(
                '$time',
                style: kshadowTextStyle,
              ),
            ),
            Image.asset(
              '$imageName',
              scale: 4,
            ),
            FittedBox(
              child: Text(
                '$temperature°C',
                style: kshadowTextStyle
              ),
            )
          ],
        ),
      ),
    );
  }
}
