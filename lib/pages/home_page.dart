import 'package:flutter/material.dart';
import 'package:weather/dataApi/test_api.dart';
import 'package:weather/model/current_weather.dart';
import 'package:weather/ui/colors.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  CurrentWeather? _currentWeather = CurrentWeather(
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

  void _searchCityWeather() async {
    final (longtitude, latitude) =
        await fetchCityCoordinates(_searchController.text);
    CurrentWeather weather =
        await fetchCurrentCityWeather(longtitude, latitude);

    setState(() {
      _currentWeather = weather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        TextField(
          controller: _searchController,
          onSubmitted: (_) => _searchCityWeather(),
          decoration: const InputDecoration(
            hintText: 'Search for a city',
            suffixIcon: Icon(Icons.search),
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
          ),
        ),
        const SizedBox(height: 12.0),
        Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud, size: 48.0),
                  Text(_currentWeather!.temperature.toString() + ' °C'),
                  Text(_currentWeather!.temperatureMax.toString() + ' °C'),
                  Text(_currentWeather!.weatherText)
                ],
              ),
            )),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                height: 150,
                color: containerBackground,
                child: Center(
                  child: Text(_currentWeather!.rain.toString() + ' mm'),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Container(
                  height: 150,
                  color: containerBackground,
                  child: Center(
                    child: Text(_currentWeather!.uvIndex.toString()),
                  )),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                height: 150,
                color: containerBackground,
                child: Center(
                  child: Text(_currentWeather!.airQualityIndex.toString()),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Container(
                height: 150,
                color: containerBackground,
                child: Center(
                  child: Text(_currentWeather!.pressure.toString() + ' hPa'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Container(
          height: 200,
          color: containerBackground,
          child: Center(
            child: Text("sunrise and sunset"),
          ),
        ),
      ],
    );
  }
}
