import 'package:chabbat_pay/components/menu.dart';
import 'package:chabbat_pay/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteChabbat extends StatelessWidget {
  RouteChabbat({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  CollectionReference chabbatsCollection =
      FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
          .collection('chabbats');

  @override
  Widget build(BuildContext context) {
    // Load the authenticated user from the provider
    User? _user = Provider.of<User?>(context);

    String _chabbat = 'Tazria';

    return Scaffold(
      appBar: AppBar(
        title: Text('Chabbat $_chabbat'),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: const Icon(Icons.person),
              label: const Text('Logout'),
              style: TextButton.styleFrom(primary: Colors.grey[800])),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Text('User 1'),
              Text('User 2'),
            ],
          ),
        ),
      ),
      drawer: MenuApp(),
    );
  }
}
