import 'package:chabbat_pay/models/args/chabbat.dart';
import 'package:chabbat_pay/models/chabbat.dart';
import 'package:chabbat_pay/utilities/id_to_user.dart';
import 'package:flutter/material.dart';

class TabOverview extends StatelessWidget {
  const TabOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArgsChabbat;
    ChabbatModel _chabbat = args.chabbat;

    return Center(
      child: Column(
        children: [
          Center(
            child: Tooltip(
              child: Chip(
                label: const Text("Status"),
                avatar: Icon(_chabbat.open
                    ? Icons.lock_open_rounded
                    : Icons.lock_rounded),
                backgroundColor:
                    _chabbat.open ? Colors.green[300] : Colors.red[300],
              ),
              message: _chabbat.open ? "open" : "closed",
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
