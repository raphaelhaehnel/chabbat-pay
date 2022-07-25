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

  Future getLastChabbat(_user) async {
    // Get the users from the database
    var collectionUsers =
        FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
            .collection('users');

    // Get this user from the collection of users
    var docUsersSnapshot = await collectionUsers.doc(_user!.uid).get();

    if (docUsersSnapshot.exists) {
      Map<String, dynamic>? dataUser = docUsersSnapshot.data();

      // Get the chabbats from the database
      var collectionChabbats =
          FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
              .collection('chabbats');

      // Get the list of chabbats of the current user
      List chabbatsList = dataUser?['chabbats'];

      // Store the most recent date
      Timestamp maxDate = Timestamp(0, 0);

      ChabbatModel maxChabbat = ChabbatModel(date: maxDate);

      for (int i = 0; i < chabbatsList.length; i++) {
        String chabbatID = chabbatsList[i];

        // Get the chabbat from the database
        var docChabbatsSnapshot = await collectionChabbats.doc(chabbatID).get();

        if (docChabbatsSnapshot.exists) {
          Map<String, dynamic>? data = docChabbatsSnapshot.data();
          Timestamp date = data?['date'];
          bool open = data?['open'];

          // If the date of this chabbat is the most recent, we pick it
          if (date.compareTo(maxDate) > 0 && open) {
            maxDate = date;

            maxChabbat = ChabbatModel(
                id: chabbatID,
                name: data?['name'],
                open: data?['open'],
                admin: data?['admin'],
                users: data?['users'],
                date: data?['date']);
          }
        }
      }
      return maxChabbat;
    }
    throw Exception('Error handling firebase data');
  }
}
