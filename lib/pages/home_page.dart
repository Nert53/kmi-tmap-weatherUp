import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather/dataApi/test_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchCity = '';

  void _searchCityWeather() async {
    int cityCode = await fetchCityCode(_searchController.text);
    var currentWeather = await fetchCurrentWeather(cityCode);

    setState(() {
      print(currentWeather.weatherText);
      print("test priontu");
      _searchCity = "testinnng";
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
        Text(_searchCity),
        Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud, size: 48.0),
                Text('Temperature'),
                Text('high = low'),
                Text("weaather descipriton")
              ],
            ),
          )
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                height: 150,
                color: Colors.blueGrey,
                child: Center(child: Text("rain"),),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Container(
                height: 150,
                color: Colors.blueGrey,
                child: Center(child: Text("uv index"),)
              ),
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
                color: Colors.blueGrey,
                child: Center(child: Text("air quality"),),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Container(
                height: 150,
                color: Colors.blueGrey,
                child: Center(child: Text("pressure"),),
              ),
            ),
          ],
        ),
         const SizedBox(height: 12.0),
        Container(
          height: 200,
          color: Colors.blueGrey,
          child: Center(child: Text("sunrise and sunset"),),
        ),
      ],
    );
  }
}
