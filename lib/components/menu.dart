import 'package:flutter/material.dart';
import '../items/user.dart';

class MenuApp extends StatelessWidget {
  const MenuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () => {
                    if (route != null && route.settings.name == '/')
                      {Navigator.pop(context)}
                    else
                      {Navigator.pushNamed(context, '/')}
                  }),
          ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () => {
                    if (route != null && route.settings.name == '/profile')
                      {Navigator.pop(context)}
                    else
                      {
                        Navigator.pushNamed(context, '/profile',
                            arguments: User())
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
