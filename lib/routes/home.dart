import 'package:chabbat_pay/components/home_button.dart';
import 'package:chabbat_pay/components/log_out_action.dart';
import 'package:chabbat_pay/models/args/chabbat.dart';
import 'package:chabbat_pay/services/auth.dart';
import 'package:chabbat_pay/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/menu.dart';

class RouteHome extends StatefulWidget {
  const RouteHome({Key? key}) : super(key: key);

  @override
  State<RouteHome> createState() => _RouteHomeState();
}

class _RouteHomeState extends State<RouteHome> {
  // Instance of the firebase module
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    // Load the authenticated user from the provider
    User? _user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [
          LogOutAction(),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Loading last chabbat...")));
                    DatabaseService(uid: _user!.uid)
                        .getLastChabbat(_user)
                        .then((chabbat) async {
                      if (chabbat.date == Timestamp(0, 0)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Cannot display last chabbat")));
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          '/chabbat',
                          arguments: ArgsChabbat(
                              chabbat: chabbat,
                              users: await DatabaseService(uid: _user.uid)
                                  .getAllUsers(),
                              menu: true),
                        );
                      }
                    });
                  },
                  child: const Text('Last chabbat'),
                ),
                width: 180,
              ),
            ),
            const HomeButton(route: '/home/join', name: 'Join chabbat'),
            const HomeButton(route: '/home/new', name: 'Create chabbat'),
          ],
        ),
      ),
      drawer: const MenuApp(),
    );
  }
}
