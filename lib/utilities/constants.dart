import 'package:flutter/material.dart';

const kTempTextStyle = TextStyle(
  fontFamily: 'Julius',
  color: Colors.black,
  fontSize: 60.0,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'DG',
  color: Colors.black,
  fontSize: 30.0,
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'DG',
);

const kConditionTextStyle = TextStyle(
  fontSize: 60.0,
);

const kInputStyleDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  icon: Icon(
    Icons.location_city,
  ),
  hintText: 'Enter city name...',
  hintStyle: TextStyle(
    color: Colors.black,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide.none,
  ),
);

const kCreditScreenTextStyle =
    TextStyle(fontSize: 25.0, fontFamily: 'DG', color: Colors.white);

const kshadowTextStyle = TextStyle(color: Colors.white, shadows: [
  Shadow(
      // bottomLeft
      offset: Offset(-1.0, -1.0),
      color: Colors.black),
  Shadow(
      // bottomRight
      offset: Offset(1.0, -1.0),
      color: Colors.black),
  Shadow(
      // topRight
      offset: Offset(1.0, 1.0),
      color: Colors.black),
  Shadow(
      // topLeft
      offset: Offset(-1.0, 1.0),
      color: Colors.black),
]);

const kExtendedWeatherDetailsStyle = TextStyle(
  fontFamily: 'DG',
  fontSize: 20.0,
  color: Color(0xFF182C61),

);
