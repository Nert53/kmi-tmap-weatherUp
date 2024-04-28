import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool sendNotifications = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          child: ListTile(
              title: const Text('Sending daily notifications'),
              subtitle: const Text('Celsius'),
              trailing: Switch(
                  value: sendNotifications,
                  onChanged: (value) {
                    setState(() {
                      sendNotifications = value;
                    });
                  })),
        ),
        const ListTile(
          title: Text('Temperature unit'),
          subtitle: Text('Celsius'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
}
