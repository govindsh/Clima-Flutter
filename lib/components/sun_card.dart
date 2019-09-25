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
          Expanded(
            child: isSunRise
                ? Image.asset(
                    'images/sunrise.png',
                  )
                : Image.asset(
                    'images/sunset.png',
                  ),
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
