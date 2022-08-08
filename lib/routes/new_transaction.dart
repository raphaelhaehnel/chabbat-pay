import 'dart:io';
import 'dart:typed_data';
import 'package:chabbat_pay/models/chabbat.dart';
import 'package:chabbat_pay/models/checker_join.dart';
import 'package:chabbat_pay/models/transaction.dart';
import 'package:chabbat_pay/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('dd-MM-yyyy H:mm');

class RouteNewTransaction extends StatefulWidget {
  const RouteNewTransaction({Key? key}) : super(key: key);

  @override
  State<RouteNewTransaction> createState() => _RouteNewTransactionState();
}

class _RouteNewTransactionState extends State<RouteNewTransaction> {
  PlatformFile? _pickedfile;
  UploadTask? _uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    setState(() {
      _pickedfile = result.files.first;
    });
  }

  Future<String> uploadFile() async {
    // Define the name file for the FirebaseStorage
    final path =
        'files/${_pickedfile!.name}'; // TODO change name for each file (add user, date, and other)

    // The file stored as a byte file
    Uint8List file = _pickedfile!.bytes!;

    // The directory of the destination
    final ref = FirebaseStorage.instanceFor(app: Firebase.app('myFirebase'))
        .ref()
        .child(path);

    _uploadTask = ref.putData(file);

    final snapshot = await _uploadTask!.whenComplete(() {});

    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    ChabbatModel _chabbat = args["chabbat"];
    bool _menu = args["menu"];

    User? _user = Provider.of<User?>(context);

    DatabaseService databaseService = DatabaseService(uid: _user!.uid);

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool isButtonDisabled = false;

    final _transactionName = TextEditingController();
    final _transactionPrice = TextEditingController();

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      _transactionName.dispose();
      _transactionPrice.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _transactionName,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Transaction name',
                  ),
                ),
                TextFormField(
                  controller: _transactionPrice,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty || !isNumeric(value)) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Transaction price',
                  ),
                ),
                ElevatedButton(
                    onPressed: selectFile, child: const Text('Upload image')),
                TextFormField(
                  enabled: false,
                  initialValue: _user.displayName,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Creator',
                  ),
                ),
                TextFormField(
                  enabled: false,
                  initialValue: formatter.format(DateTime.now()),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Date',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (!isButtonDisabled) {
                            setState(() => isButtonDisabled = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing...')));
                            String urlImage = await uploadFile();
                            TransactionModel transaction = TransactionModel(
                              name: _transactionName.text,
                              user: _user.uid,
                              image: urlImage,
                              cost: double.parse(_transactionPrice.text),
                              date: Timestamp.now(),
                            );
                            if (await databaseService.addTransactionToChabbat(
                                    _chabbat.id, transaction) ==
                                Checker.done) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Transaction added !')));
                            }
                            Navigator.pop(
                                context, _chabbat.addTransaction(transaction));
                          }
                        }
                      },
                      child: const Text('Submit')),
                ),
                if (_pickedfile != null)
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Image.memory(_pickedfile!.bytes!),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  if (double.tryParse(s) == null) {
    return false;
  }
  return double.parse(s) > 0;
}
