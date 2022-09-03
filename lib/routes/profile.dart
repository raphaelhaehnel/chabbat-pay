import 'package:chabbat_pay/routes/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/menu.dart';

class RouteProfile extends StatelessWidget {
  const RouteProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load the argument from the route
    // final args = ModalRoute.of(context)!.settings.arguments as User;

    User? _user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileRoute()),
                );
              },
              child: const Text('Modify'),
              style: TextButton.styleFrom(primary: Colors.grey[800])),
        ],
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text('Name'),
              subtitle: Center(child: Text(_user?.displayName ?? 'null')),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Email'),
              subtitle: Center(child: Text(_user?.email ?? 'null')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                      context,
                      '/profile/history',
                    ),
                child: const Text('Open chabbat history')),
          ),
        ],
      ),
      drawer: const MenuApp(),
    );
  }
}
