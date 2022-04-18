import 'package:chabbat_pay/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChabbatHistoryRoute extends StatelessWidget {
  const ChabbatHistoryRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chabbat history'),
      ),
      body: FutureBuilder(
        future: getChabbatList(_user!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index]),
                    subtitle: const Text('sutitle'),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        initialData: null,
      ),
    );
  }

  Future<List?> getChabbatList(uid) async {
    DocumentSnapshot documentSnapshot =
        await DatabaseService(uid: uid).getUserData();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>;
      return data['chabbats'];
    }
    return null;
  }

  //TODO we want to get all the chabbat and pick only the chabbats for which we have the id's
  foo(uid) async {
    CollectionReference chabbatsColection =
        DatabaseService(uid: uid).chabbatsCollection;
    DocumentSnapshot documentSnapshot =
        await chabbatsColection.doc(chabbatId).get();
  }
}
