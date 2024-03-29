import 'dart:math';
import 'package:chabbat_pay/models/chabbat.dart';
import 'package:chabbat_pay/models/transaction.dart';
import 'package:chabbat_pay/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chabbat_pay/models/checker_join.dart';

generateId(int n) {
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

  FirebaseFirestore firebaseFirestore =
      FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'));

  final CollectionReference userCollection =
      FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
          .collection('users');

  final CollectionReference chabbatsCollection =
      FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
          .collection('chabbats');

  closeChabbat(chabbatId) {
    chabbatsCollection.doc(chabbatId).update({"open": false});
  }

// TODO : this code don't have to be here ! Please use two databases: one for users and one for chabbats
  // foo(DocumentSnapshot item) {

  //   // We run a transaction so the update takes place only after the information is updated on the server.
  //   FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
  //       .runTransaction((transaction) async {
  //     DocumentSnapshot freshSnap = await transaction.get(item.reference);
  //     await transaction
  //         .update(freshSnap.reference, {'credit': freshSnap['credit'] + 1});
  //   });

  //   // If you want instant but not robust update:
  //   // item.reference.update({'credit': item['credit'] + 1});
  // }

  // final sfDocRef = db.collection("cities").doc("SF");
  // db.runTransaction((transaction) async {
  //   final snapshot = await transaction.get(sfDocRef);
  //   // Note: this could be done without a transaction
  //   //       by updating the population using FieldValue.increment()
  //   final newPopulation = snapshot.get("population") + 1;
  //   transaction.update(sfDocRef, {"population": newPopulation});
  // }).then(
  //   (value) => print("DocumentSnapshot successfully updated!"),
  //   onError: (e) => print("Error updating document $e"),
  // );

  Future updateUserData(String name, List chabbats, points, mail) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'chabbats': chabbats,
      'points': points,
      'mail': mail,
    });
  }

  /// Create a new chabbat
  Future createChabbatData(String name, Currency currency) async {
    String chabbatId = generateId(6);

    await chabbatsCollection.doc(chabbatId).set({
      'name': name,
      'date': Timestamp.now(),
      'admin': uid,
      'open': true,
      'users': <String>[uid],
      'transactions': <TransactionModel>[],
      'currency': currency.name,
    });

    addChabbatToUser(chabbatId);
    return chabbatId;
  }

  Future<ChabbatModel> getChabbat(String chabbatId) async {
    DocumentSnapshot documentSnapshot =
        await chabbatsCollection.doc(chabbatId).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>;
      ChabbatModel chabbat = ChabbatModel.fromMap(data, chabbatId);
      return chabbat;
    } else {
      throw Exception("No chabbatId corresponding");
    }
  }

  Future<Checker> addTransactionToChabbat(
      String chabbatId, TransactionModel transaction) async {
    DocumentSnapshot documentSnapshot =
        await chabbatsCollection.doc(chabbatId).get();
    if (documentSnapshot.exists) {
      ChabbatModel chabbat = ChabbatModel.fromMap(
          documentSnapshot.data() as Map<String, dynamic>, chabbatId);

      List<TransactionModel> transactions = chabbat.transactions;

      transactions.add(transaction);
      await chabbatsCollection.doc(chabbatId).update(
          {'transactions': transactions.map((elmt) => elmt.toMap()).toList()});

      return Checker.done;
    } else {
      return Checker.idNotExists;
    }
  }

  Future<Checker> addUserToChabbat(String chabbatId) async {
    DocumentSnapshot documentSnapshot =
        await chabbatsCollection.doc(chabbatId).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>;
      List users = data['users'];
      if (users.contains(uid)) {
        return Checker.userExists;
      }
      users.add(uid);
      await chabbatsCollection.doc(chabbatId).update({'users': users});
      return Checker.done;
    } else {
      return Checker.idNotExists;
    }
  }

  Future<Checker> addChabbatToUser(String chabbatId) async {
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    if (documentSnapshot.exists) {
      // 1- Retrive the old list of chabbats (DONE)
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>;
      List chabbats = data['chabbats'];
      if (chabbats.contains(chabbatId)) {
        return Checker.chabbatExists;
      }
      // 2- Retrive the id of the new created chabbat (DONE)
      // 3- Add the id to the list of chabbats
      chabbats.add(chabbatId);
      await userCollection.doc(uid).update({'chabbats': chabbats});
      return Checker.done;
    } else {
      return Checker.userNotExists;
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

  Future<Map<String, String>> getAllUsers() async {
    QuerySnapshot myDocs = await userCollection.get();
    // Iterable users = myDocs.docs.map((doc) => MapEntry(doc.id, doc["name"]));

    Map<String, String> users = {
      for (var item in myDocs.docs.map((doc) => MapEntry(doc.id, doc["name"])))
        item.key: item.value
    };
    return users;
  }

  Future<bool> updateName(String name) async {
    try {
      userCollection.doc(uid).update({'name': name});
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateEmail(String mail) async {
    try {
      userCollection.doc(uid).update({'mail': mail});
    } catch (e) {
      return false;
    }
    return true;
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

  Future<ChabbatModel> getLastChabbat(_user) async {
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

            maxChabbat = ChabbatModel.fromMap(data!, chabbatID);
          }
        }
      }
      return maxChabbat;
    }
    throw Exception('Error handling firebase data');
  }
}
