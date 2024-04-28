import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/dataApi/external_api.dart';
import 'package:weather/model/current_weather.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  late List<Map> forecast = [];
  bool isLoading = false;

  @override
  void initState() {
    _fetchCities();
    super.initState();
  }

  void _fetchCities() async {
    setState(() {
      isLoading = true;
    });

    var prefs = await SharedPreferences.getInstance();
    var city = prefs.getString('currentCity') ?? '';
    if (city.isNotEmpty) {
      var (longtitude, latitude, _, _) = await fetchCityCoordinates(city);
      forecast = await fetchDailyForecast(longtitude, latitude);
    }
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : forecast.isEmpty
                ? const Text('No city selected. Please select a city.')
                : buildForecast());
  }

  buildForecast() {
    return ListView(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      children: forecast.map((day) {
        return Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
              ),
            ],
          ),
          child: ListTile(
            title: Text(day['weekDay']),
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
            trailing: Text('${day['temperatureMax']}°C / ${day['temperatureMin']} °C, ${day['precipitationSum']} mm'),
          ),
        );
      }).toList(),
    );
  }
}
