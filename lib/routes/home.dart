import 'package:chabbat_pay/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/menu.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, DbCollection;

//
class RouteHome extends StatefulWidget {
  const RouteHome({Key? key}) : super(key: key);

  @override
  State<RouteHome> createState() => _RouteHomeState();
}

class _RouteHomeState extends State<RouteHome> {
  // Instance of the firebase module
  final AuthService _auth = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // String containing the name of the user, from the text input
  String test = "null";


  // Controller to clear the text field
  final fieldText = TextEditingController();

  // Retrieves the collection from the Firebase database
  CollectionReference bandnames =
      FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
          .collection('bandnames');

  // The function adds a new user to Firebase
  Future<void> addUser(BuildContext context, String name, int credit) {
    // Call the user's CollectionReference to add a new user
    return bandnames
        .add({
          'name': name, // John Doe
          'credit': credit, // Stokes and Sons
        })
        .then((value) => Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("User $name successfully added !"))))
        .catchError((error) => Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add user: $error"))));
  }

  @override
  Widget build(BuildContext context) {
    // Load data if already exist

    // Load the authenticated user from the provider
    User? _user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: ElevatedButton(
                  onPressed: () => {},
                  child: const Text('Opened chabbats'),
                ),
                width: 180,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                          context,
                          '/home/join',
                        ),
                    child: const Text('Join chabbat')),
                width: 180,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                          context,
                          '/home/new',
                        ),
                    child: const Text('Create chabbat')),
                width: 180,
              ),
            ),
          ],
        ),
      ),
      drawer: MenuApp(),
    );
  }
}
