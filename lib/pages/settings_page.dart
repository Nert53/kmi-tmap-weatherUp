import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

enum TemperatureUnit { celsius, fahrenheit }

class _SettingsPageState extends State<SettingsPage> {
  bool _sendNotifications = true;

  @override
  void initState() {
    _loadSettings();
    super.initState();
  }

  _loadSettings() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _sendNotifications = prefs.getBool('sendNotifications') ?? false;
    });
  }

  void _saveSettings() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('sendNotifications', !_sendNotifications);
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
      children: [
        Container(
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
            child: ListTile(
              title: const Text('Sending daily notifications'),
              subtitle: const Text('Daily in the morning at 7.30'),
              contentPadding: const EdgeInsets.only(left: 16, right: 8),
              trailing: Switch(
                  value: _sendNotifications,
                  thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Icon(Icons.check);
                    }
                    return const Icon(Icons.close);
                  }),
                  onChanged: (_) => _saveSettings()),
            )),
      ],
    );
  }
}
