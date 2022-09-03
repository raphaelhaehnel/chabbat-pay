import 'package:chabbat_pay/models/args/chabbat.dart';
import 'package:chabbat_pay/models/chabbat.dart';
import 'package:chabbat_pay/services/database.dart';
import 'package:chabbat_pay/utilities/id_to_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabOverview extends StatefulWidget {
  TabOverview({Key? key}) : super(key: key);

  @override
  State<TabOverview> createState() => _TabOverviewState();
}

class _TabOverviewState extends State<TabOverview> {
  bool _openChabbat = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArgsChabbat;
    ChabbatModel _chabbat = args.chabbat;
    _openChabbat = _chabbat.open;

    User? _user = Provider.of<User?>(context);
    DatabaseService databaseService = DatabaseService(uid: _user!.uid);

    return Center(
      child: Column(
        children: [
          Center(
            child: GestureDetector(
              onTap: () async {
                if (_chabbat.admin == _user.uid && _chabbat.open) {
                  String? resultDialog = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: const Text(
                                "Do you really want to close the chabbat ? This action is irreversible !"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ));
                  if (resultDialog == "OK") {
                    _chabbat.open = false;
                    setState(() {
                      _openChabbat = false;
                    });
                    databaseService.closeChabbat(_chabbat.id);
                  }
                }
              },
              child: Tooltip(
                child: Chip(
                  label: const Text("Status"),
                  avatar: Icon(_chabbat.open
                      ? Icons.lock_open_rounded
                      : Icons.lock_rounded),
                  backgroundColor:
                      _openChabbat ? Colors.green[300] : Colors.red[300],
                ),
                message: _openChabbat ? "open" : "closed",
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                itemCount: _chabbat.usersId.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(idToName(_chabbat.usersId[index], context)),
                      trailing: _chabbat.admin == _chabbat.usersId[index]
                          ? const Tooltip(
                              child: Icon(Icons.admin_panel_settings),
                              message: "admin",
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
