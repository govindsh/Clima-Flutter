import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SunCard extends StatelessWidget {
  bool isSunRise;
  int timestamp;
  double height;
  double width;

  SunCard({this.timestamp, this.isSunRise});

  String getLocalTime(int time) {
    if (time == 0) {
      return 'Unavailable';
    } else {
      var humanReadableTimestamp =
          DateTime.fromMillisecondsSinceEpoch(time * 1000).toLocal();
      var format = new DateFormat.Md().add_jm();
      var hourFormat = format.format(humanReadableTimestamp);
      return hourFormat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: CircleBorder(side: BorderSide(style: BorderStyle.none)),
      color: isSunRise ? Colors.yellowAccent : Colors.deepOrange,
      child: Column(
        children: <Widget>[
          FittedBox(
            child: Text(
              isSunRise ? 'Sunrise' : 'Sunset',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'DG',
                  fontSize: 15.0),
            ),
          ),
          isSunRise
              ? Image.asset(
                  'images/sunrise.png',
                  scale: 8,
                )
              : Image.asset(
                  'images/sunset_1.png',
                  scale: 8,
                ),
          FittedBox(
            child: Text(
              getLocalTime(timestamp),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'DG',
                  fontSize: 15.0),
            ),
          ),
        ],
      ),
    );
  }
}
