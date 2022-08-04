import 'package:chabbat_pay/models/chabbat.dart';
import 'package:flutter/material.dart';

class TabOverview extends StatelessWidget {
  const TabOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    ChabbatModel _chabbat = args["chabbat"];

    return Center(
      child: Column(
        children: [
          const Text("Participants"),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                itemCount: _chabbat.users.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_chabbat.users[index]),
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
