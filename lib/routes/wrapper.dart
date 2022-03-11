import 'package:chabbat_pay/main.dart';
import 'package:chabbat_pay/routes/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print(user);

    if (user == null) {
      return LoginScreen();
    } else {
      return RouteHome();
    }
  }
}
