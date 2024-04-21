import 'package:flutter/material.dart';
import 'package:weather/pages/first_page.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0x000066a8),
          // ···
          brightness: Brightness.light,
        ),
      ),
      home: const FirstPage(),
    );
  }
}
