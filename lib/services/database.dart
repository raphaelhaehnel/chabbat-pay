import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
          .collection('users');

  Future updateUserData(String name, List chabbats, points, mail) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'chabbats': chabbats,
      'points': points,
      'mail': mail,
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    return await userCollection.doc(uid).get();
  }
}
