import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;

  Future<void> getCurrentLocation() async {
    Position position;
    try {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

      longitude = position.longitude;
      latitude = position.latitude;
    } catch (e) {
      print(e);
    }
    print(position);
  }
}
