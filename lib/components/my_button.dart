import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const FirebaseData(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}

class FirebaseData extends StatelessWidget {
  const FirebaseData({Key? key}) : super(key: key);

  Future updateData(DocumentSnapshot item) async {
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
            .collection('bandnames')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 300.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot item =
                      (snapshot.data! as QuerySnapshot).docs[index];

                  return ListTile(
                      title: Center(child: Text(item['name'])),
                      subtitle: Center(child: Text(item['credit'].toString())),
                      onTap: () => updateData(item));
                },
                shrinkWrap: true,
              ),
            );
          } else {
            return const Text('No data.');
          }
        });
  }
}
