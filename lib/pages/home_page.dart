// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:weather/dataApi/external_api.dart';
import 'package:weather/model/current_weather.dart';
import 'package:weather/ui/colors.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  CurrentWeather? _currentWeather = CurrentWeather(
      city: '',
      temperature: 0,
      temperatureMax: 0,
      temperatureMin: 0,
      weatherText: "none",
      rain: 0,
      uvIndex: 1,
      airQualityIndex: 1,
      pressure: 0,
      sunrise: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 6, 30),
      sunset: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 18, 30));

  void _searchCityWeather() async {
    final (longtitude, latitude, city, country) =
        await fetchCityCoordinates(_searchController.text);
    CurrentWeather weather =
        await fetchCurrentCityWeather(longtitude, latitude);

    setState(() {
      _currentWeather = weather;
      _searchController.text = city;
    });
  }

  void _searchCurrentCityWeather() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    var locationData = await location.getLocation();
    CurrentWeather weather =
        await fetchCurrentCityWeather(locationData.longitude!, locationData.latitude!);

    setState(() {
      _currentWeather = weather;
      _searchController.text = weather.city;
    });
  }

  var decoratedContainer = Container();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          children: [
            Expanded(
              child: Material(
                elevation: 3.0,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _searchCityWeather(),
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Search for a city',
                    suffixIcon: Icon(Icons.search_outlined),
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
            ),
            const SizedBox(width: 12.0),
            FloatingActionButton(
              onPressed: () {
                _searchCurrentCityWeather();
              },
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 4.0,
              child: const Icon(Icons.gps_fixed_outlined),
            )
          ],
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
              child: smallContainerWdigetDecimal(
                  'Rain [mm]', _currentWeather!.rain, 5),
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
              child: smallContainerWidgetWhole(
                  'UV index [0-11]', _currentWeather!.uvIndex.round(), 11),
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
                child: smallContainerWidgetWhole('Air Quality [0-100]',
                    _currentWeather!.airQualityIndex, 100),
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
                  child: smallContainerWdigetDecimal(
                      'Pressure [hPa]', _currentWeather!.pressure, 1300)),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Container(
          height: 200,
          padding: EdgeInsets.all(16.0),
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
          child: sunsetSunriseWidget(
              _currentWeather!.sunrise, _currentWeather!.sunset),
        ),
      ],
    );
  }

  smallContainerWdigetDecimal(String title, double value, double totalValue) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            value.toString(),
            style: const TextStyle(fontSize: 24.0),
          ),
        ],
      ),
      roundValueIndicator(value, totalValue),
    ]);
  }

  smallContainerWidgetWhole(String title, int value, int totalValue) {
    Color selectedColor;
    if (totalValue == 11) {
      selectedColor = uvIndexColor(value);
    } else {
      selectedColor = airQualityIndexColor(value);
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            value.toString(),
            style: const TextStyle(fontSize: 24.0),
          ),
        ],
      ),
      straightValueIndicator(value, totalValue, selectedColor),
    ]);
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
          Icons.wb_sunny_outlined,
          size: 64.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  roundValueIndicator(double value, double totalValue) {
    if (value < 1) {
      value = value * 10;
      totalValue = totalValue * 10;
    }
    return CircularStepProgressIndicator(
      totalSteps: totalValue.round(),
      roundedCap: (_, __) => true,
      currentStep: value.round(),
      stepSize: 8,
      selectedStepSize: 8,
      selectedColor: Theme.of(context).colorScheme.primary,
      unselectedColor: Colors.grey[200],
      padding: 0,
      width: 60,
      height: 60,
    );
  }

  straightValueIndicator(int value, int totalValue, Color selectedColor) {
    return Transform.flip(
        flipY: true,
        child: StepProgressIndicator(
          totalSteps: totalValue,
          currentStep: value,
          size: 20,
          selectedSize: 20,
          selectedColor: selectedColor,
          roundedEdges: const Radius.circular(10),
          unselectedColor: Colors.grey[200]!,
          padding: 0,
          direction: Axis.vertical,
        ));
  }

  sunsetSunriseWidget(DateTime sunrise, DateTime sunset) {
    DateTime currentTime = DateTime.now();
    Duration daylightDurationMinutes = sunset.difference(sunrise);
    Duration timePastSunriseMinutes = currentTime.difference(sunrise);
    if (timePastSunriseMinutes > daylightDurationMinutes) {
      timePastSunriseMinutes =
          daylightDurationMinutes - const Duration(minutes: 2);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sunrise and Sunset',
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 40.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat.Hm().format(sunrise)),
            Text(DateFormat.Hm().format(sunset)),
          ],
        ),
        const SizedBox(height: 8.0),
        StepProgressIndicator(
          totalSteps: daylightDurationMinutes.inMinutes,
          currentStep: timePastSunriseMinutes.inMinutes,
          size: 20,
          selectedSize: 20,
          selectedColor: Theme.of(context).colorScheme.primary,
          roundedEdges: const Radius.circular(10),
          unselectedColor: Colors.grey[200]!,
          padding: 0,
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/sunrise_icon.svg',
              color: Colors.orange[300],
            ),
            SvgPicture.asset(
              'assets/sunset_icon.svg',
              color: Colors.orange[900],
            ),
          ],
        )
      ],
    );
  }
}

airQualityIndexColor(int value) {
  switch (value) {
    case < 26:
      return Colors.green;
    case < 51:
      return const Color.fromARGB(255, 172, 235, 0);
    case < 76:
      return Colors.yellow;
    case < 101:
      return Colors.orange;
    default:
      return Colors.red;
  }
}

uvIndexColor(int value) {
  switch (value) {
    case < 3:
      return Colors.green;
    case < 6:
      return Colors.yellow;
    case < 8:
      return Colors.orange;
    case < 11:
      return Colors.red;
    default:
      return Colors.purple;
  }
}
