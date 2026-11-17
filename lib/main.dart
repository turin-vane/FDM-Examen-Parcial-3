//import 'package:aplicacion2/features/auth/screens/auth_check_screen.dart';
import 'package:flutter/material.dart';
import 'features/weight/screens/weight_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrackPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blueAccent),
      ),
      //home: const AuthCheckScreen(),
      home: const WeightScreen(),
    );
  }
}

