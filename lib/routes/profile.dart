import 'package:flutter/material.dart';
import '../components/menu.dart';
import '../items/user.dart';
import '../components/listItems.dart';

class RouteProfile extends StatelessWidget {
  const RouteProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load the argument from the route
    // final args = ModalRoute.of(context)!.settings.arguments as User;
    List<User> listItems = [];
    if (ModalRoute.of(context)!.settings.arguments != null) {
      listItems = ModalRoute.of(context)!.settings.arguments as List<User>;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: ListItems(listItems: listItems),
      drawer: MenuApp(arguments: listItems),
    );
  }
}
