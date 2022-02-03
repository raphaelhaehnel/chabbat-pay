import 'package:flutter/material.dart';
import './routes/home.dart';
import './routes/profile.dart';
import './items/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const RouteHome(),
        '/profile': (context) => const RouteProfile(),
      },
    );
  }
}
