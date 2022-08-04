import 'package:chabbat_pay/models/checker_join.dart';
import 'package:chabbat_pay/services/auth.dart';
import 'package:chabbat_pay/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinChabatRoute extends StatefulWidget {
  JoinChabatRoute({Key? key}) : super(key: key);

  @override
  State<JoinChabatRoute> createState() => _JoinChabatRouteState();
}

class _JoinChabatRouteState extends State<JoinChabatRoute> {
  displaySnackbar(String popupText) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(popupText)));
  }

  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<User?>(context);
    final DatabaseService databaseService = DatabaseService(uid: _user!.uid);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String? _chabbatId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join a chabbat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    setState(() {
                      _chabbatId = value;
                    });
                    if (value == null || value.isEmpty) {
                      return 'Please enter a chabbat ID';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Type the chabbat code here',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Joining chabbat...')));
                        if (_formKey.currentState!.validate()) {
                          Checker result1 = await databaseService
                              .addUserToChabbat(_chabbatId!);

                          if (result1 == Checker.idNotExists) {
                            displaySnackbar("This chabbat id not exists");
                            return;
                          }
                          Checker result2 = await databaseService
                              .addChabbatToUser(_chabbatId!);

                          if (result1 == Checker.userExists &&
                              result2 == Checker.chabbatExists) {
                            displaySnackbar(
                                "You are already in this chabbat !");
                            return;
                          }

                          if (result2 == Checker.done &&
                              result1 == Checker.done) {
                            Navigator.pop(context);
                            displaySnackbar("Chabbat added !");
                            return;
                          }

                          if (result2 == Checker.userNotExists) {
                            displaySnackbar(
                                "Your are not existing. Please contact customer service");
                            print(
                                "Your are not existing. Please contact customer service");
                          }

                          if (result2 == Checker.chabbatExists) {
                            displaySnackbar(
                                "The chabbat already exists in your history. Please contact customer service");
                            print(
                                "The chabbat already exists in your history. Please contact customer service");
                          }

                          if (result1 == Checker.userExists) {
                            displaySnackbar(
                                "Your id already exists in the chabbat user list. Please contact customer service");
                            print(
                                "Your id already exists in the chabbat user list. Please contact customer service");
                          }
                        }
                      },
                      child: const Text('OK')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
