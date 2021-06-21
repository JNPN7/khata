import 'package:flutter/material.dart';
import 'package:khata/screens/client.dart';
import 'package:khata/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/home': (context) => Home(),
        '/client': (context) => ClientScreen(),
      }
    );
  }
}