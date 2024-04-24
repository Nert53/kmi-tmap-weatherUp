import 'package:flutter/material.dart';
import 'package:weather/pages/main_page.dart';

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
        scaffoldBackgroundColor: Color.fromARGB(255, 240, 240, 240),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0x00006fad),
          brightness: Brightness.light,
        ),
      ),
      home: const FirstPage(),
    );
  }
}
