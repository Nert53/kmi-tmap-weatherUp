import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:weather/constants.dart';
import 'package:weather/model/city.dart';
import 'package:weather/model/current_weather.dart';

Future<(double, double, String, String)> fetchCityCoordinates(
    String city) async {
  String editedCity = city.trim();
  int countOfCities = 1;
  var apiUrl =
      'https://geocoding-api.open-meteo.com/v1/search?name=$editedCity&count=$countOfCities';
  var result = await http.get(Uri.parse(apiUrl));

  if (result.statusCode != 200) {
    return (0.0, 0.0, '', '');
  }
  var jsonResult = jsonDecode(result.body)["results"][0];

  double cityLongitude = jsonResult['longitude'];
  double cityLatitude = jsonResult['latitude'];
  String cityName = jsonResult['name'];
  String country = jsonResult['country_code'];
  return (cityLongitude, cityLatitude, cityName, country);
}

Future<(String, String, String)> fetchCityOfCoordinates(
    double longtitude, double latitude) async {
  final queryParams = {
    'lat': latitude.toString(),
    'lon': longtitude.toString(),
    'api_key': GEOCODE_MAPS_KEY,
  };
  final httpsUri = Uri.https('geocode.maps.co', '/reverse', queryParams);

  final response = await http.get(httpsUri);
  if (response.statusCode != 200) {
    return ('', '', '');
  }

  var jsonResult = jsonDecode(response.body);
  return (
    jsonResult['address']['city'].toString(),
    jsonResult['address']['county'].toString(),
    jsonResult['address']['country_code'].toString()
  );
}

Future<String> fetchCountryOfCity(String city) async {
  String editedCity = city.trim();
  int countOfCities = 1;
  var apiUrl =
      'https://geocoding-api.open-meteo.com/v1/search?name=$editedCity&count=$countOfCities';
  var result = await http.get(Uri.parse(apiUrl));

  if (result.statusCode != 200) {
    return "none";
  }
  var jsonResult = jsonDecode(result.body)["results"][0];

  String country = jsonResult['country_code'];
  return country;
}

Future<CurrentWeather> fetchCurrentCityWeather(
    double longtitude, double latitude) async {
  String temperatureUnit = 'celsius';
  var apiUrl =
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longtitude&current=temperature_2m,is_day,precipitation,rain,weather_code,surface_pressure&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max&temperature_unit=$temperatureUnit&timezone=auto';
  var result = await http.get(Uri.parse(apiUrl));
  if (result.statusCode != 200) {
    return CurrentWeather(
        city: '',
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

  var weatherText =
      await convertWeatherCodeToText(jsonResult['current']['weather_code']);
  var airQualityIndex = await fetchCityAirQualityIndex(longtitude, latitude);
  var (cityName, county, countyCode) =
      await fetchCityOfCoordinates(longtitude, latitude);

  return CurrentWeather(
      city: cityName,
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

Future<List<Map>> fetchMultipleCitiesWeather(List<City> cities) async {
  List<Map> citiesWeather = [];
  String citiesLatitude = '';
  String citiesLongitude = '';

  for (var city in cities) {
    citiesLatitude += '${city.latitude},';
    citiesLongitude += '${city.longitude},';
  }

  final queryParams = {
    'latitude': citiesLatitude,
    'longitude': citiesLongitude,
    'current':
        "temperature_2m,apparent_temperature,precipitation,rain,weather_code",
    'daily': 'uv_index_max',
    'timezone': 'auto',
  };
  final httpsUri = Uri.https('api.open-meteo.com', '/v1/forecast', queryParams);

  final response = await http.get(httpsUri);
  if (response.statusCode == 200) {
    var jsonResult = jsonDecode(response.body);

    for (var cityWeather in jsonResult) {
      var data = {
        'temperature': cityWeather['current']['temperature_2m'],
        'apparentTemperature': cityWeather['current']['apparent_temperature'],
        'weatherCode':
            convertWeatherCodeToText(cityWeather['current']['weather_code']),
      };

      citiesWeather.add(data);
    }

    return citiesWeather;
  }
  return [];
}

Future<List<Map>> fetchDailyForecast(
    double longtitude, double latitude) async {
  List<Map> dailyWeather = [];

  final queryParams = {
    'latitude': latitude.toString(),
    'longitude': longtitude.toString(),
    'timezone': 'auto',
    'daily':
        'weather_code,temperature_2m_max,temperature_2m_min,daylight_duration,precipitation_sum',
  };
  final httpsUri = Uri.https('api.open-meteo.com', '/v1/forecast', queryParams);

  final response = await http.get(httpsUri);
  if (response.statusCode == 200) {
    var jsonResult = jsonDecode(response.body)['daily'];

    for (var i = 0; i < jsonResult['time'].length; i++) {
      var day = convertDayNumToText(DateTime.parse(jsonResult['time'][i]).weekday.toString());

      var data = {
        'weekDay': day,
        'temperatureMax': jsonResult['temperature_2m_max'][i],
        'temperatureMin': jsonResult['temperature_2m_min'][i],
        'daylightDuration': jsonResult['daylight_duration'][i],
        'precipitationSum': jsonResult['precipitation_sum'][i],
      };

      dailyWeather.add(data);
    }

    return dailyWeather;
  }
  return [];
}

String convertDayNumToText(String day) {
  switch (day) {
    case '1':
      return 'Monday';
    case '2':
      return 'Tuesday';
    case '3':
      return 'Wednesday';
    case '4':
      return 'Thursday';
    case '5':
      return 'Friday';
    case '6':
      return 'Saturday';
    case '7':
      return 'Sunday';
    default:
      return 'Unknown';
  }
}
