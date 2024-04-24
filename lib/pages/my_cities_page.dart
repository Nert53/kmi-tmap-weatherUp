import 'package:flutter/material.dart';
import 'package:weather/data/city_database.dart';
import 'package:weather/model/city.dart';

class MyCitiesPage extends StatefulWidget {
  const MyCitiesPage({super.key});

  @override
  State<MyCitiesPage> createState() => _MyCitiesPageState();
}

class _MyCitiesPageState extends State<MyCitiesPage> {
  late List<City> cities;
  bool isLoading = false;

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
              : buildCities()
    );
  }

  Widget buildCities() {
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return ListTile(
          title: Text(city.name),
          subtitle: Text(city.country),
        );
      },
    );
  }
}
