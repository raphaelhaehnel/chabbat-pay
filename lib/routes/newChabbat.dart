import 'package:chabbat_pay/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewChabatRoute extends StatefulWidget {
  const NewChabatRoute({Key? key}) : super(key: key);

  @override
  State<NewChabatRoute> createState() => _NewChabatRouteState();
}

class _NewChabatRouteState extends State<NewChabatRoute> {
  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<User?>(context);

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String? _chabbatName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a chabbat'),
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
                      _chabbatName = value;
                    });
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Chabbat name',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () => {
                            if (_formKey.currentState!.validate())
                              {
                                DatabaseService(uid: _user!.uid)
                                    .createChabbatData(_chabbatName!),
                                Navigator.pop(context)
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
