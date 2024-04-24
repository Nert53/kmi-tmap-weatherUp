import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather/dataApi/test_api.dart';
import 'package:weather/model/current_weather.dart';
import 'package:weather/ui/colors.dart';

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

  var decoratedContainer = Container();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Material(
          elevation: 3.0,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: TextField(
            controller: _searchController,
            onSubmitted: (_) => _searchCityWeather(),
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Search for a city',
              suffixIcon: Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        Container(
            height: 200,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: containerBackground,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 1),
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: mainContainerWidget(
                _currentWeather!.temperature.toString(),
                _currentWeather!.weatherText,
                _currentWeather!.temperatureMax.toString(),
                _currentWeather!.temperatureMin.toString())),
        const SizedBox(height: 12.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Expanded(
            child: Container(
              height: 150,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: containerBackground,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: smallContainerWdiget(
                  'Rain [mm]', _currentWeather!.rain.toString()),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Container(
              height: 150,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: containerBackground,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: smallContainerWdiget('UV index [0-11]',
                  _currentWeather!.uvIndex.round().toString()),
            ),
          ),
        ]),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                height: 150,
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: containerBackground,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 1),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: smallContainerWdiget('Air Quality [0-100]',
                    _currentWeather!.airQualityIndex.toString()),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: containerBackground,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: smallContainerWdiget(
                      'Pressure [hPa]', _currentWeather!.pressure.toString())),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Container(
          height: 200,
          decoration: const BoxDecoration(
            color: containerBackground,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 1),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Center(
            child: Text("sunrise and sunset"),
          ),
        ),
      ],
    );
  }

  smallContainerWdiget(String title, String value) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 12.0),
            Text(
              value,
              style: const TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ],
    );
  }

  mainContainerWidget(
      String currentTemp, String weatherText, String highTemp, String lowTemp) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Weather',
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 12.0),
            Text(
              '$currentTemp °C',
              style: const TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                Text(
                  'High: $highTemp ° Low: $lowTemp °',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                )
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              weatherText,
              style: const TextStyle(fontSize: 20.0),
            ),
          ],
        ),
        Icon(
          Icons.sunny,
          size: 64.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
