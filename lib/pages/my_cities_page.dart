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
    super.initState();
    _fetchCities();
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
    return const Center(
      child: Text('My Cities'),
    );
  }
}