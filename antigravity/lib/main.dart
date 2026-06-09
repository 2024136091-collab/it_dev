import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ElevatorApp());
}

class ElevatorApp extends StatelessWidget {
  const ElevatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '승강기 정보검색',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE94560),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
