import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shortuid/shortuid.dart';
import 'package:weather/data/city_database.dart';
import 'package:weather/dataApi/external_api.dart';
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
  late bool _isConnected;
  bool isLoading = false;

  final chooseCityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future _checkInternetConnection() async {
    setState(() {
      isLoading = true;
    });

    _isConnected = await InternetConnectionChecker().hasConnection;

    setState(() {
      isLoading = false;
    });
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isConnected
              ? _pages[_selectedIndex]
              : buildWarningContainer("No internet connection!"),
      floatingActionButton: _pages[_selectedIndex] is MyCitiesPage
          ? FloatingActionButton(
              onPressed: () {
                openChooseCityDialog(context);
              },
              tooltip: 'Add City',
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              child: const Icon(Icons.add_outlined),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _navigateToPage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.area_chart_outlined),
            selectedIcon: Icon(Icons.area_chart),
            label: 'Forecast',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_city_outlined),
            selectedIcon: Icon(Icons.location_city),
            label: 'My Cities',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
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
                    chooseCityController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'))
            ],
          ));

  void addCity(String cityName) async {
    final (longtitude, latitude, city, countryCode) =
        await fetchCityCoordinates(cityName);

    City newCity = City(
        id: ShortUid.create(),
        name: city,
        country: countryCode,
        latitude: latitude,
        longitude: longtitude);

    await CityDatabase.instance.addCity(newCity);
  }

  buildWarningContainer(String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orange[800]!, width: 3),
        ),
        child: Text(
          message,
          style: TextStyle(
              color: Colors.orange[800]!,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
