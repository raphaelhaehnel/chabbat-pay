import 'package:chabbat_pay/routes/editProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/menu.dart';

class RouteProfile extends StatelessWidget {
  RouteProfile({Key? key}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    // Load the argument from the route
    // final args = ModalRoute.of(context)!.settings.arguments as User;

    User? _user = Provider.of<User?>(context);

    if (_user != null) {
      _user.updateDisplayName('Jonathan').then((value) => null);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileRoute()),
                );
              },
              child: const Text('Modify'),
              style: TextButton.styleFrom(primary: Colors.grey[800])),
        ],
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text('Name'),
              subtitle: Center(child: Text(_user?.displayName ?? 'null')),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Email'),
              subtitle: Center(child: Text(_user?.email ?? 'null')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {}, child: const Text('Open chabbat history')),
          ),
        ],
      ),
      drawer: const MenuApp(),
    );
  }

  updateData(DocumentSnapshot item) {
    // We run a transaction so the update takes place only after the information is updated on the server.
    FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
        .runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(item.reference);
      await transaction
          .update(freshSnap.reference, {'credit': freshSnap['credit'] + 1});
    });

    // If you want instant but not robust update:
    // item.reference.update({'credit': item['credit'] + 1});
  }
}
