import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/LoadingScreen');
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      upperBound: 100.0
    );
    controller.forward();

    controller.addListener(() {
      setState(() {});
    });

    super.initState();
    startTime();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFECC735),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image(
            image: AssetImage('images/logo.png'),
          ),
          Hero(
            tag: 'weatherman',
            child: Image(
              image: AssetImage('images/weatherman.png'),
              height: 120.0,
            ),
          ),
          Text(
            'WEATHERMAN',
            style: TextStyle(
              fontFamily: 'Major Mono',
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
              '${controller.value.toInt()} %',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Major Mono',
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
          )
        ],
      ),
    );
  }
}
