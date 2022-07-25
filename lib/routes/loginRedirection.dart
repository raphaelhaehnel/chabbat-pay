import 'package:chabbat_pay/routes/chabbat.dart';
import 'package:chabbat_pay/routes/home.dart';
import 'package:chabbat_pay/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chabbat_pay/models/chabbat.dart';

class LoginRedirection extends StatelessWidget {
  LoginRedirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<User?>(context);

    // We need to get the user data that correspond to the uid, and check if
    // there is an opened chabbat in the list of chabbats

    DatabaseService(uid: _user!.uid).getLastChabbat(_user).then((chabbat) {
      if (chabbat.date == Timestamp(0, 0)) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/chabbat',
          arguments: {"chabbat": chabbat, "menu": true},
        );
      }
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
