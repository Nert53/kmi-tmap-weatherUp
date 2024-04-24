import 'package:flutter/material.dart';
import 'package:shortuid/shortuid.dart';
import 'package:weather/data/city_database.dart';
import 'package:weather/dataApi/test_api.dart';
import 'package:weather/model/city.dart';
import 'package:weather/pages/forecast_page.dart';
import 'package:weather/pages/settings_page.dart';
import 'package:weather/pages/home_page.dart';
import 'package:weather/pages/my_cities_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _selectedIndex = 0;
  final chooseCityController = TextEditingController();

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = const [
    HomePage(),
    ForecastPage(),
    MyCitiesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('WeatherUP',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onPrimary)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: _pages[_selectedIndex] is MyCitiesPage
          ? FloatingActionButton(
              onPressed: () {
                openChooseCityDialog(context);
              },
              tooltip: 'Add City',
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _navigateToPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.area_chart),
            label: 'Forecast',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: 'My Cities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void openChooseCityDialog(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Choose a city'),
            content: TextField(
              controller: chooseCityController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'City name',
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    addCity(chooseCityController.text);
                    var cities = CityDatabase.instance.getAllCities();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'))
            ],
          ));

  void addCity(String cityName) async {
    final (longtitude, latitude) = await fetchCityCoordinates(cityName);
    final country = await fetchCountryOfCity(cityName);

    City newCity = City(
        id: ShortUid.create(),
        name: cityName,
        country: country,
        latitude: latitude,
        longitude: longtitude);

    await CityDatabase.instance.addCity(newCity);
  }
}
