import 'package:chabbat_pay/services/auth.dart';
import 'package:flutter/material.dart';

class LogOutAction extends StatelessWidget {
  const LogOutAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return TextButton.icon(
        onPressed: () async {
          await _auth.signOut();
          Navigator.pushReplacementNamed(context, '/');
        },
        icon: const Icon(Icons.person),
        label: const Text('Logout'),
        style: TextButton.styleFrom(primary: Colors.grey[800]));
  }
}
