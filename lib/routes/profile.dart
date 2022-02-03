import 'package:flutter/material.dart';
import '../components/menu.dart';
import '../items/user.dart';

class RouteProfile extends StatelessWidget {
  const RouteProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load the argument from the route
    final args = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.name),
      ),
      body: Text(args.credit.toString()),
      drawer: const MenuApp(),
    );
  }
}
