import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String keyType;
  final String value;
  WeatherCard({@required this.keyType, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: Container(
          width: 100,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                child: Text(
                  '$keyType',
                  style: TextStyle(
                    color: Color(0xFFCDD2DF),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              FittedBox(
                child: Text(
                  '$value',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontFamily: 'Julius',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
