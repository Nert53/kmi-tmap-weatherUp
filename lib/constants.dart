// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

const GEOCODE_MAPS_KEY = '662625b755c44585313957sthe99d41';

final Map<String, IconData> WEATHER_ICONS = {
  'neutral': WeatherIcons.day_cloudy_high,
  'sunny': WeatherIcons.day_sunny,
  'cloudy': WeatherIcons.cloud,
  'rainy': WeatherIcons.rain_mix,
  'thunderstorm': WeatherIcons.lightning,
  'snow': WeatherIcons.snow,
  'hot': WeatherIcons.hot
};
