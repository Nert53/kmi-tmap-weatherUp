import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/dataApi/api_keys.dart';
import 'package:weather/data/current_weather.dart';

Future<int> fetchCityCode(String city) async {
  var apiUrl =
      'http://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=$accuWeatrherApiKey&q=$city';
  var result = await http.get(Uri.parse(apiUrl));
  var jsonResult = jsonDecode(result.body)[0]; // takes first (closest) result
  int cityCode = int.parse(jsonResult['Key']);

  return cityCode;
}

Future<CurrentWeather> fetchCurrentWeather(int cityCode) async {
  var apiUrl =
      'http://dataservice.accuweather.com/currentconditions/v1/$cityCode?apikey=$accuWeatrherApiKey';
  var result = await http.get(Uri.parse(apiUrl));
  var jsonResult = jsonDecode(result.body)[0];

  var current = CurrentWeather(
    temperatureC: jsonResult['Temperature']['Metric']['Value'],
    temperatureF: jsonResult['Temperature']['Imperial']['Value'],
    weatherText: jsonResult['WeatherText'],
  );

  return current;
}
