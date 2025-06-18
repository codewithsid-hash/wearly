import 'package:flutter/material.dart';
import 'package:wearly/scanner_page.dart';
import 'package:wearly/splashScreen.dart';


void main() {
  runApp(const WearlyApp());
}

class WearlyApp extends StatelessWidget {
  const WearlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wearly',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const WearlySplashScreen()
    );
  }
}
