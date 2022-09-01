import 'package:chabbat_pay/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileRoute extends StatefulWidget {
  const EditProfileRoute({Key? key}) : super(key: key);

  @override
  EditProfileRouteState createState() => EditProfileRouteState();
}

class EditProfileRouteState extends State<EditProfileRoute> {
  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<User?>(context);
    final _formKey = GlobalKey<FormState>();

    final _newName = TextEditingController(text: _user!.displayName);
    final _newEmail = TextEditingController(text: _user.email);

    DatabaseService databaseService = DatabaseService(uid: _user.uid);

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      _newName.dispose();
      _newEmail.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _newName,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Name',
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newEmail,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail),
                  labelText: 'Email adress',
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Processing Data...'),
                                duration: Duration(milliseconds: 1000),
                              ),
                            );

                            _user.updateDisplayName(_newName.text);
                            _user.updateEmail(_newEmail.text);

                            if (await databaseService
                                    .updateName(_newName.text) &&
                                await databaseService
                                    .updateEmail(_newEmail.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Profile modified successfully !')),
                              );
                            }

                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
