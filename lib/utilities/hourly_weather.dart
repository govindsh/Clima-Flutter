import 'package:flutter/material.dart';

class HourlyWeatherCard extends StatelessWidget {

  final String time;
  final String imageName;
  final String temperature;

  HourlyWeatherCard({@required this.time, @required this.imageName, @required this.temperature});


  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: <Widget>[
        Card(
        color: Colors.white,
          child: Container(
            width: 100,
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FittedBox(
                  child: Text(
                    '$time',
                    style: TextStyle(
                      color: Color(0xFFCDD2DF),
                    ),
                  ),
                ),
                Image.asset('$imageName', scale: 4,),
                FittedBox(
                  child: Text(
                    '$temperature°C',
                    style: TextStyle(
                      color: Color(0xFFCDD2DF),
                    ),
                  ),
                )
              ],
            ),
          ),
      ),
      ],
    );

  }
}
