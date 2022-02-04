import 'package:flutter/material.dart';
import '../components/menu.dart';
import '../items/user.dart';

class RouteProfile extends StatelessWidget {
  const RouteProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load the argument from the route
    // final args = ModalRoute.of(context)!.settings.arguments as User;
    final args = ModalRoute.of(context)!.settings.arguments as List<User>;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.toString()),
      ),
      body: ListView.builder(
        itemCount: args.length,
        itemBuilder: (context, index) {
          final item = args[index];

          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.credit.toString()),
          );
        },
      ),
      drawer: const MenuApp(),
    );
  }
}
