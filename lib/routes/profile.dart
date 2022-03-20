import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../components/menu.dart';
import '../items/student.dart';
import '../components/listItems.dart';
import '../components/my_button.dart';

class RouteProfile extends StatelessWidget {
  RouteProfile({Key? key}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    // Load the argument from the route
    // final args = ModalRoute.of(context)!.settings.arguments as User;

    List<Student> listItems = [];
    if (ModalRoute.of(context)!.settings.arguments != null) {
      listItems = ModalRoute.of(context)!.settings.arguments as List<Student>;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream:
                  FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
                      .collection('bandnames')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Container(
                      height: 300.0, // Change as per your requirement
                      width: 300.0, // Change as per your requirement
                      child: ListView.builder(
                        itemCount:
                            (snapshot.data! as QuerySnapshot).docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot item =
                              (snapshot.data! as QuerySnapshot).docs[index];

                          return ListTile(
                              title: Center(child: Text(item['name'])),
                              subtitle: Center(
                                  child: Text(item['credit'].toString())),
                              onTap: () => updateData(item));
                        },
                        shrinkWrap: true,
                      ),
                    ),
                  );
                } else {
                  return const Text('No data.');
                }
              })
        ],
      ),
      drawer: MenuApp(arguments: listItems),
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
