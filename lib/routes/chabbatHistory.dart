import 'dart:convert';

import 'package:chabbat_pay/models/chabbat.dart';
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
    DatabaseService dbService = DatabaseService(uid: _user!.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chabbat history'),
      ),
      body: FutureBuilder(
        future: dbService.getChabbatsDetails(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ChabbatModel chabbat = snapshot.data[index];
                  return ListTile(
                    title: Text(chabbat.name),
                    subtitle: Text(chabbat.id),
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
}
