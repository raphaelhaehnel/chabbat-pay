import 'dart:convert';
import 'dart:math';
import 'package:chabbat_pay/models/chabbat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

generate_id(int n) {
  var random = Random();
  String id = '';
  for (int i = 0; i < n; i++) {
    String digit = random.nextInt(9).toString();
    id += digit;
  }
  return id;
}

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

  /// Create a new chabbat
  Future createChabbatData(String name) async {
    String chabbatId = generate_id(6);

    // TODO: we have to get the result of the future
    await chabbatsCollection.doc(chabbatId).set({
      'name': name,
      'date': Timestamp.now(),
      'admin': uid,
      'open': true,
      'users': {'unStringID': 555},
    });

    addChabbatToUser(chabbatId);
    return chabbatId;
  }

  Future addChabbatToUser(String chabbatId) async {
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    if (documentSnapshot.exists) {
      // 1- Retrive the old list of chabbats (DONE)
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>;
      List chabbats = data['chabbats'];

      // 2- Retrive the id of the new created chabbat (DONE)
      // 3- Add the id to the list of chabbats
      chabbats.add(chabbatId);
      await userCollection.doc(uid).update({'chabbats': chabbats});
    } else {
      print('PROBLEM !!');
    }
  }

  Future<DocumentSnapshot> getUserData() async {
    return await userCollection.doc(uid).get();
  }

  Future<List> getChabbatsList() async {
    DocumentSnapshot documentSnapshot = await getUserData();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return data['chabbats'];
    }
    return [];
  }

  Future<List<ChabbatModel>> getChabbatsDetails() async {
    List chabbatsList = await getChabbatsList();

    List<ChabbatModel> chabbatDetailedList = [];

    for (String chabbatId in chabbatsList) {
      DocumentSnapshot documentSnapshot =
          await chabbatsCollection.doc(chabbatId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> chabbat =
            documentSnapshot.data() as Map<String, dynamic>;

        ChabbatModel chabbatObject = ChabbatModel.fromMap(chabbat, chabbatId);
        chabbatDetailedList.add(chabbatObject);
      }
    }

    return chabbatDetailedList;
  }
}
