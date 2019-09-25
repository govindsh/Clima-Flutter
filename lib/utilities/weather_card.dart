import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String keyType;
  final String value;
  final String imageName;
  WeatherCard({@required this.keyType, @required this.value, this.imageName});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(imageName),
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4), BlendMode.dstATop),
            ),
          ),
          width: 100,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                child: Text(
                  '$keyType',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
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
                    fontWeight: FontWeight.bold,
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
