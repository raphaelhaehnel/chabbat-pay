import 'package:chabbat_pay/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteNewChabat extends StatefulWidget {
  const RouteNewChabat({Key? key}) : super(key: key);

  @override
  State<RouteNewChabat> createState() => _RouteNewChabatState();
}

class _RouteNewChabatState extends State<RouteNewChabat> {
  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<User?>(context);

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool isButtonDisabled = false;

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
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    setState(() {
                      _chabbatName = value;
                    });
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Chabbat name',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (!isButtonDisabled) {
                            setState(() => isButtonDisabled = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing...')));

                            String chabbatId =
                                await DatabaseService(uid: _user!.uid)
                                    .createChabbatData(_chabbatName!);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Chabbat $_chabbatName created ! ID: $chabbatId')));
                          }
                        }
                      },
                      child: const Text('Ok')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
