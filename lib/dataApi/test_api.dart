import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:weather/dataApi/api_keys.dart';
import 'package:weather/model/current_weather.dart';

Future<int> fetchCityCode(String city) async {
  var apiUrl =
      'http://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=$accuWeatrherApiKey&q=$city';
  var result = await http.get(Uri.parse(apiUrl));
  var jsonResult = jsonDecode(result.body)[0]; // takes first (closest) result
  int cityCode = int.parse(jsonResult['Key']);

  return cityCode;
}

Future<(double, double)> fetchCityCoordinates(String city) async {
  String editedCity = city.trim();
  int countOfCities = 1;
  var apiUrl =
      'https://geocoding-api.open-meteo.com/v1/search?name=$editedCity&count=$countOfCities';
  var result = await http.get(Uri.parse(apiUrl));

  if (result.statusCode != 200) {
    return (0.0, 0.0);
  }
  var jsonResult = jsonDecode(result.body)["results"][0];

  double cityLongitude = jsonResult['longitude'];
  double cityLatitude = jsonResult['latitude'];
  return (cityLongitude, cityLatitude);
}

Future<CurrentWeather> fetchCurrentCityWeather(
    double longtitude, double latitude) async {
  String temperatureUnit = 'celsius';
  var apiUrl =
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longtitude&current=temperature_2m,is_day,precipitation,rain,weather_code,surface_pressure&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max&temperature_unit=$temperatureUnit&timezone=auto';
  var result = await http.get(Uri.parse(apiUrl));
  if (result.statusCode != 200) {
    return CurrentWeather(
        temperature: 0,
        temperatureMax: 0,
        temperatureMin: 0,
        weatherText: "none",
        rain: 0,
        uvIndex: 1,
        airQualityIndex: 1,
        pressure: 0,
        sunrise: DateTime.now(),
        sunset: DateTime.now());
  }
  var jsonResult = jsonDecode(result.body);

  var weatherCode = jsonResult['current']['weather_code'];
  var weatherText = await convertWeatherCodeToText(weatherCode);

  var airQualityIndex = await fetchCityAirQualityIndex(longtitude, latitude);

  return CurrentWeather(
      temperature: jsonResult['current']['temperature_2m'],
      temperatureMax: jsonResult['daily']['temperature_2m_max'][0],
      temperatureMin: jsonResult['daily']['temperature_2m_min'][0],
      weatherText: weatherText,
      rain: jsonResult['current']['rain'],
      uvIndex: jsonResult['daily']['uv_index_max'][0],
      airQualityIndex: airQualityIndex,
      pressure: jsonResult['current']['surface_pressure'],
      sunrise: DateTime.parse(jsonResult['daily']['sunrise'][0]),
      sunset: DateTime.parse(jsonResult['daily']['sunset'][0]));
}

Future<int> fetchCityAirQualityIndex(double longtitude, double latitude) async {
  var apiUrl =
      'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=$latitude&longitude=$longtitude&current=european_aqi';
  var result = await http.get(Uri.parse(apiUrl));
  if (result.statusCode != 200) {
    return 0;
  }
  var jsonResult = jsonDecode(result.body);
  return jsonResult['current']['european_aqi'].round();
}

Future<String> convertWeatherCodeToText(int weatherCdde) async {
  String jsonPath = 'assets/wmo_codes_descriptions.json';
  var result = await rootBundle.loadString(jsonPath);
  var jsonResult = jsonDecode(result);
  var text = jsonResult[weatherCdde.toString()]['day']['description'];

  return text;
}
