import 'package:flutter/material.dart';
import '../items/user.dart';

class MenuApp extends StatelessWidget {
  const MenuApp({Key? key, this.arguments}) : super(key: key);

  final arguments;

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () => {
                    if (route != null && route.settings.name == '/home')
                      {Navigator.pop(context)}
                    else
                      {
                        Navigator.pushReplacementNamed(context, '/home',
                            arguments: arguments)
                      }
                  }),
          ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () => {
                    if (route != null && route.settings.name == '/profile')
                      {Navigator.pop(context)}
                    else
                      {
                        Navigator.pushReplacementNamed(context, '/profile',
                            arguments: arguments)
                        // Here we are giving User as parameter to the route /profile
                      }
                  }),
          ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
