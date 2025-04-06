import 'package:flutter/material.dart';
import 'package:lab1/map/user_map.dart';
import 'package:lab1/user_list_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'ride_history_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' App Multiscreen ',
      initialRoute: '/ ',
      routes: {
        '/ ': (context) => LoginScreen(),
        '/ home ': (context) => HomeScreen(),
        '/ map': (context) => UserMap(),
        '/ profile ': (context) => ProfileScreen(),
        '/ users': (context) => UserListScreen(),
        '/ rides': (context) => RideHistoryScreen(),
      },
    );
  }
}
