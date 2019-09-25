import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:clima/screens/nointernet_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/services/networking.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  bool showSpinner = false;
  String cityName;
  Set<String> searchResults = Set();
  final TextEditingController _typeAheadController = TextEditingController();

  Future<List<dynamic>> searchResultsForCity(String city) async {
    searchResults.clear();
    String body = '{'
        '"query": "$city",'
        '"hitsPerPage": "4",'
        '"language": "en",'
        '"type": "city"'
        '}';
    try {
      Response response =
      await post('https://places-dsn.algolia.net/1/places/query', body: body);
      var searchResult = jsonDecode(response.body)['hits'][0]['locale_names'][0] +
          "," +
          jsonDecode(response.body)['hits'][0]['administrative'][0];
      searchResults.add(searchResult);
    } catch (e) {
      print(e);
      if (e.toString().contains('SocketException')) {
        searchResults.clear();
        searchResults.add('Check your internet connection.');
      }
    }
    return searchResults.toList();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/tranquil-unsplash.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 50.0,
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            cursorColor: Colors.black,
                            style: TextStyle(
                              color: Colors.black
                            ),
                            controller: this._typeAheadController,
                            decoration: kInputStyleDecoration,
                          ),
                          suggestionsCallback: (pattern) {
                            return searchResultsForCity(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            this._typeAheadController.text = suggestion;
                            if (suggestion.toString().contains('-')) {
                              var tempCity = suggestion.toString().trim();
                              cityName = tempCity.split('-')[0];
                            } else {
                              cityName = suggestion.toString().split(",")[0];
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () async {

                    // Display spinner to show progress
                    setState(() {
                      showSpinner = true;
                    });
                    var weatherDataMap = Map();

                    // First check for internet connection

                    if (await NetworkHelper.checkInternetConnection()) {
                      // Internet connection is there
                      weatherDataMap = await WeatherModel().getCityWeather(cityName);
                      print('Weather data map for city $cityName - $weatherDataMap');

                      // City not found - null data returned to the user - handle it
                      if (weatherDataMap == null) {
                        Navigator.push(context, new MaterialPageRoute(builder: (context) {
                          return LocationScreen(
                            locationWeather: null,
                            locationHourWeather: null,
                          );
                        }));
                      }

                      // Return actual weather data returned by the API
                      else {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) {
                              return LocationScreen(
                                locationWeather: weatherDataMap['weatherData'],
                                locationHourWeather: weatherDataMap['hourlyData'],
                              );
                            }));
                      }
                    }

                    // No internet connection so route to the "No Internet" Page.
                    else {
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) {
                            return NoInternetScreen();
                          }));
                    }

                    // Stop displaying spinner
                    setState(() {
                      showSpinner = false;
                    });
                  },
                  color: Colors.blue,
                  child: Text(
                    'Get Weather',
                    style: kButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
