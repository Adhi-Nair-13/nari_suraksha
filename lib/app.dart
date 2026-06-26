import 'package:flutter/material.dart';
import 'features/onboarding/onboarding_screen.dart';

class NarisurakshaApp extends StatelessWidget {
  const NarisurakshaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nari Suraksha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const OnboardingScreen(),
    );
  }
} // Clean closing bracket here!