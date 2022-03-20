import 'package:chabbat_pay/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginRedirection extends StatefulWidget {
  const LoginRedirection({Key? key}) : super(key: key);

  @override
  State<LoginRedirection> createState() => _LoginRedirectionState();
}

class _LoginRedirectionState extends State<LoginRedirection> {
  String _textFromFile = 'null';

  _LoginRedirectionState() {}

  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<User?>(context);

    // We need to get the user data that correspond to the uid, and check if
    // there is an opened chabbat in the list of chabbats

    //
    getLastChabbat(_user).then((val) => setState(() {
          _textFromFile = val.toString();
        }));

    return Container(
      child: Text(_textFromFile),
    );
  }

  Future getLastChabbat(_user) async {
    var collection =
        FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
            .collection('users');
    var docSnapshot = await collection.doc(_user!.uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var value = data?['chabbats'][0]; // <-- The value you want to retrieve.
      return value; // Call setState if needed.
    }
    return 'Failed to load data...';
  }
}
