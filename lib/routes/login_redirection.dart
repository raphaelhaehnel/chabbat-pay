import 'package:chabbat_pay/models/args/chabbat.dart';
import 'package:chabbat_pay/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class LoginRedirection extends StatelessWidget {
  LoginRedirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<User?>(context);

    // This widget will rebuilt if _user gets a new value, because of the Stream Provider
    if (_user != null) {
      DatabaseService(uid: _user.uid)
          .getLastChabbat(_user)
          .then((chabbat) async {
        if (chabbat.date == Timestamp(0, 0)) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else {
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushReplacementNamed(
              context,
              '/chabbat',
              arguments: ArgsChabbat(
                  chabbat: chabbat,
                  users: await DatabaseService(uid: _user.uid).getAllUsers(),
                  menu: true),
            );
          });
        }
      });
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
