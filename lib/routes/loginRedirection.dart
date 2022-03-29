import 'package:chabbat_pay/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chabbat_pay/models/chabbat.dart';

class LoginRedirection extends StatefulWidget {
  const LoginRedirection({Key? key}) : super(key: key);

  @override
  State<LoginRedirection> createState() => _LoginRedirectionState();
}

class _LoginRedirectionState extends State<LoginRedirection> {
  ChabbatModel _chabbat = ChabbatModel(date: Timestamp(0, 0));

  _LoginRedirectionState() {}

  @override
  Widget build(BuildContext context) {
    // TODO: we only want to build the login redirection, not the chabbat page !

    User? _user = Provider.of<User?>(context);

    // We need to get the user data that correspond to the uid, and check if
    // there is an opened chabbat in the list of chabbats

    //
    getLastChabbat(_user).then((val) => setState(() {
          _chabbat = val;
        }));

    return Scaffold(
      appBar: AppBar(title: Text(_chabbat.name)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [Text(_chabbat.date.toDate().toString())],
        ),
      ),
    );
  }

  Future getLastChabbat(_user) async {
    // Get the users from the database
    var collectionUsers =
        FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
            .collection('users');

    // Get this user from the collection of users
    var docUsersSnapshot = await collectionUsers.doc(_user!.uid).get();

    if (docUsersSnapshot.exists) {
      Map<String, dynamic>? dataUser = docUsersSnapshot.data();

      // Get the chabbats from the database
      var collectionChabbats =
          FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
              .collection('chabbats');

      // Get the list of chabbats of the current user
      List chabbatsList = dataUser?['chabbats'];

      // Store the most recent date
      Timestamp maxDate = Timestamp(0, 0);

      ChabbatModel maxChabbat = ChabbatModel(date: maxDate);

      for (int i = 0; i < chabbatsList.length; i++) {
        String chabbatID = chabbatsList[i];

        // Get the chabbat from the database
        var docChabbatsSnapshot = await collectionChabbats.doc(chabbatID).get();

        if (docChabbatsSnapshot.exists) {
          Map<String, dynamic>? data = docChabbatsSnapshot.data();
          Timestamp date = data?['date'];
          bool open = data?['open'];

          // If the date of this chabbat is the most recent, we pick it
          if (date.compareTo(maxDate) > 0 && open) {
            maxDate = date;

            maxChabbat = ChabbatModel(
                id: chabbatID,
                name: data?['name'],
                open: data?['open'],
                admin: data?['admin'],
                users: data?['users'],
                date: data?['date']);
          }
        } else {
          throw Exception('Error handling firebase data');
        }
      }
      return maxChabbat;
    }
    return 'Failed to load data...';
  }
}
