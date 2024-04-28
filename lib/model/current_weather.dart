class CurrentWeather {
  final String city;
  final double temperature;
  final double temperatureMax;
  final double temperatureMin;
  final String weatherText;
  final double rain;
  final double uvIndex;
  final int airQualityIndex;
  final double pressure;
  final DateTime sunrise;
  final DateTime sunset;

  CurrentWeather({
    required this.city,
    required this.temperature,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.weatherText,
    required this.rain,
    required this.uvIndex,
    required this.airQualityIndex,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
  });
}
