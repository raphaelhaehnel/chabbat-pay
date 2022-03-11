import 'package:chabbat_pay/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../components/menu.dart';
import '../items/user.dart';
import '../components/listItems.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, DbCollection;

class RouteHome extends StatefulWidget {
  const RouteHome({Key? key}) : super(key: key);

  @override
  State<RouteHome> createState() => _RouteHomeState();
}

class _RouteHomeState extends State<RouteHome> {
  final AuthService _auth = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String test = "null";
  List<User> listItems = [];

  final fieldText = TextEditingController();

  CollectionReference bandnames =
      FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
          .collection('bandnames');

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
    if (ModalRoute.of(context)!.settings.arguments != null) {
      listItems = ModalRoute.of(context)!.settings.arguments as List<User>;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: const Icon(Icons.person),
              label: const Text('Logout'),
              style: TextButton.styleFrom(primary: Colors.grey[800])),
        ],
      ),
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //TODO how to work with stream/future in Text widgets ?
              Text(_auth.user.first.toString()),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter a name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: fieldText,
                      onChanged: (value) => setState(() {
                        test = value;
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState!.validate()) {
                            // Process data.
                            if (test != null) {
                              setState(() {
                                listItems.add(User(credit: 0, name: test));
                                addUser(context, test, 0);
                              });
                            }
                            fieldText.clear();
                          }
                        },
                        child: const Text('Add participant'),
                      ),
                    ),
                  ],
                ),
              ),
              ListItems(listItems: listItems)
            ],
          ),
        );
      }),
      drawer: MenuApp(arguments: listItems),
    );
  }
}
