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
    Map<String, String> _usersMap = args.users;

    return Center(
      child: Column(
        children: [
          Icon(_chabbat.open ? Icons.lock_open_rounded : Icons.lock_rounded),
          const Text("Participants"),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                itemCount: _chabbat.usersId.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(id_to_name(_chabbat.usersId[index], context)),
                      trailing: _chabbat.admin == _chabbat.usersId[index]
                          ? const Icon(Icons.admin_panel_settings)
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
