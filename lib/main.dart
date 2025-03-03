import 'package:flutter/material.dart';
import 'package:lab1/map/user_map.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' App Multiscreen ',
      initialRoute: '/ ',
      routes: {
        '/ ': (context) => LoginScreen(),
        '/ home ': (context) => HomeScreen(),
        '/ map' : (context) => UserMap(),
        '/ profile ': (context) => ProfileScreen(),
      },
    );
  }
}
