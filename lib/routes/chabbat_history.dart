import 'package:chabbat_pay/models/args/chabbat.dart';
import 'package:chabbat_pay/models/chabbat.dart';
import 'package:chabbat_pay/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteChabbatHistory extends StatelessWidget {
  const RouteChabbatHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<User?>(context);
    DatabaseService dbService = DatabaseService(uid: _user!.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chabbat history'),
      ),
      body: FutureBuilder(
        future: dbService.getChabbatsDetails(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ChabbatModel chabbat = snapshot.data[index];

                  return Card(
                    child: ListTile(
                      title: Text(chabbat.name),
                      subtitle: Text(chabbat.id),
                      trailing: chabbat.open
                          ? const Icon(
                              Icons.lock_open,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.lock,
                              color: Colors.red,
                            ),
                      tileColor:
                          chabbat.open ? Colors.green[100] : Colors.red[100],
                      onLongPress: () {},
                      onTap: () async {
                        Navigator.pushReplacementNamed(
                          context,
                          '/chabbat',
                          arguments: ArgsChabbat(
                              chabbat: chabbat,
                              users: await DatabaseService(uid: _user.uid)
                                  .getAllUsers(),
                              menu: true),
                        );
                      },
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        initialData: null,
      ),
    );
  }
}
