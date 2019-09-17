import 'package:flutter/material.dart';
import 'package:clima/screens/loading_screen.dart';
import 'package:flutter/services.dart';
import 'package:clima/screens/splash_screen.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: SplashScreen(),
      routes: <String, WidgetBuilder> {
        '/LoadingScreen': (BuildContext context) => new LoadingScreen()
      },
    );
  }
}
