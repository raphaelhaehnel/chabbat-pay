import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

class myButton extends StatelessWidget {
  const myButton({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
            .collection('bandnames')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print((snapshot.data! as QuerySnapshot).docs[0]['name']);
            return ListView.builder(
              itemCount: (snapshot.data! as QuerySnapshot).docs.length,
              itemBuilder: (context, index) {
                final item = (snapshot.data! as QuerySnapshot).docs[index];

                return ListTile(
                  title: Center(child: Text(item['name'])),
                  subtitle: Center(child: Text(item['credit'].toString())),
                );
              },
              shrinkWrap: true,
            );
          } else {
            return const Text('No data.');
          }
        });
  }
}
