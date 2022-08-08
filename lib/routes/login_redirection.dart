import 'package:chabbat_pay/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginRedirection extends StatelessWidget {
  LoginRedirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<User?>(context);

    // This widget will rebuilt if _user gets a new value, because of the Stream Provider
    if (_user != null) {
      DatabaseService(uid: _user.uid).getLastChabbat(_user).then((chabbat) {
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
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
