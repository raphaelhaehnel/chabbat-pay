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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isButtonDisabled = false;

  final _transactionName = TextEditingController();
  final _transactionPrice = TextEditingController();
  final _transactionImage = TextEditingController();

  bool _isButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    ChabbatModel _chabbat = args["chabbat"];
    bool _menu = args["menu"];

    User? _user = Provider.of<User?>(context);
    DatabaseService databaseService = DatabaseService(uid: _user!.uid);

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    if (_pickedfile != null) {
      _transactionImage.text = _pickedfile!.name;
    }

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
                  enabled: _isButtonEnabled,
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
                  enabled: _isButtonEnabled,
                  controller: _transactionPrice,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty || !isNumeric(value)) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText:
                        "Transaction price (in ${_chabbat.currency!.symbol})",
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        enabled: _isButtonEnabled,
                        readOnly: true,
                        controller: _transactionImage,
                        autofocus: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please choose an image';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Image path',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: selectFile,
                          child: const Text('Upload image')),
                    ),
                  ],
                ),
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
                          if (_isButtonEnabled) {
                            submitButton(_user, _chabbat, databaseService);
                          }
                        }
                      },
                      child: const Text('Submit')),
                ),
                if (_isButtonEnabled == false)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  submitButton(User? _user, ChabbatModel _chabbat,
      DatabaseService databaseService) async {
    setState(() {
      _isButtonEnabled = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Processing...'),
      duration: Duration(milliseconds: 10000),
    ));

    String urlImage = await uploadFile();
    TransactionModel transaction = TransactionModel(
      name: _transactionName.text,
      user: _user!.uid,
      image: urlImage,
      cost: double.parse(_transactionPrice.text),
      date: Timestamp.now(),
    );
    if (await databaseService.addTransactionToChabbat(
            _chabbat.id, transaction) ==
        Checker.done) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Transaction added !'),
        duration: Duration(milliseconds: 1000),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Can't add transaction to chabbat")));
    }
    Navigator.pop(context, _chabbat.addTransaction(transaction));
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    setState(() {
      _pickedfile = result.files.first;
    });

    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(content: Image.memory(_pickedfile!.bytes!)));
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

    // Upload the file
    _uploadTask = ref.putData(file);

    //
    final snapshot = await _uploadTask!.whenComplete(() {});

    return await snapshot.ref.getDownloadURL();
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
