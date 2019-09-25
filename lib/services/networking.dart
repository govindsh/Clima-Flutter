import 'package:clima/services/location.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';

Location location = Location();

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {

    Response response = await get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      return decodedData;
    } else {
      print(response.statusCode);
      return response.statusCode;
    }
  }

  static Future<bool> checkInternetConnection() async {
    var connectionResult = await (Connectivity().checkConnectivity());
    if (connectionResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}