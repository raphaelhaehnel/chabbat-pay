import 'package:chabbat_pay/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_picker/currency_picker.dart';

class RouteNewChabat extends StatefulWidget {
  const RouteNewChabat({Key? key}) : super(key: key);

  @override
  State<RouteNewChabat> createState() => _RouteNewChabatState();
}

class _RouteNewChabatState extends State<RouteNewChabat> {
  final _chabbatName = TextEditingController();
  Currency? _currency;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _chabbatName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<User?>(context);

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool isButtonDisabled = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a chabbat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _chabbatName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Chabbat name',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      enabled: false,
                      initialValue: _currency == null
                          ? "Select currency"
                          : _currency!.name,
                      validator: (value) {
                        if (_currency == null) {
                          return 'Please choose a currency';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Currency',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        showCurrencyPicker(
                          context: context,
                          showFlag: true,
                          showCurrencyName: true,
                          showCurrencyCode: true,
                          onSelect: (Currency currency) {
                            setState(() {
                              _currency = currency;
                            });
                          },
                        );
                      },
                      child: const Text("Show currency picker"),
                    ),
                  ),
                ],
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

                          String chabbatId = await DatabaseService(
                                  uid: _user!.uid)
                              .createChabbatData(_chabbatName.text, _currency!);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Chabbat ${_chabbatName.text} created ! ID: $chabbatId')));
                        }
                      }
                    },
                    child: const Text('Ok')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
