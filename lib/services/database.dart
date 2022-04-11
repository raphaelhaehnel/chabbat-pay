import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
          .collection('users');

  final CollectionReference chabbatsCollection =
      FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
          .collection('chabbats');

  Future updateUserData(String name, List chabbats, points, mail) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'chabbats': chabbats,
      'points': points,
      'mail': mail,
    });
  }

  Future createChabbatData(String name) async {
    return await chabbatsCollection.doc().set({
      'name': name,
      'date': Timestamp.now(),
      'admin': uid,
      'open': true,
      'users': {'unStringID': 555},
    });
  }

  Future addChabbat() async {
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>;
      List chabbats = data['chabbats'];
      // TODO: We need to add a chabbat here.
      // 1- Retrive the old list of chabbats (DONE)
      // 2- Retrive the id of the new created chabbat (how...)
      // 3- Add the id to the list of chabbats
    } else {
      print('PROBLEM !!');
    }
  }

  Future<DocumentSnapshot> getUserData() async {
    return await userCollection.doc(uid).get();
  }
}
