import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChabbatProfile extends StatelessWidget {
  ChabbatProfile({Key? key}) : super(key: key);

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
    );
  }
}
