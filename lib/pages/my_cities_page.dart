import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather/constants.dart';
import 'package:weather/data/city_database.dart';
import 'package:weather/dataApi/external_api.dart';
import 'package:weather/model/city.dart';

class MyCitiesPage extends StatefulWidget {
  const MyCitiesPage({super.key});

  @override
  State<MyCitiesPage> createState() => _MyCitiesPageState();
}

class _MyCitiesPageState extends State<MyCitiesPage> {
  late List<City> cities;
  late List<Map<dynamic, dynamic>> weatherInCities;
  bool isLoading = false;
  Random random = Random();

  @override
  void initState() {
    _fetchCities();
    super.initState();
  }

  Future _fetchCities() async {
    setState(() {
      isLoading = true;
    });

    cities = await CityDatabase.instance.getAllCities();
    weatherInCities = await fetchMultipleCitiesWeather(cities);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : cities.isEmpty
                ? const Text('No cities added yet')
                : buildCities());
  }

  Widget buildCities() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 2,
              ),
            ],
          ),
          child: Dismissible(
            key: Key(city.id),
            onDismissed: (direction) async {
              await CityDatabase.instance.deleteCity(city.id);
            },
            background: Container(
              decoration: BoxDecoration(
                  color: Colors.red[700],
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(
                Icons.delete_outlined,
                color: Colors.white,
              ),
            ),
            child: ListTile(
                title: Text('${city.name} (${city.country})'),
                titleTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${weatherInCities[index]['temperature'].toString()} °C',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        WEATHER_ICONS[random.nextInt(3)],
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      )
                    ])),
          ),
        );
      },
    );
  }
}
