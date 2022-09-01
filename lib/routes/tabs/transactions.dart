import 'package:chabbat_pay/models/chabbat.dart';
import 'package:chabbat_pay/utilities/id_to_user.dart';
import 'package:flutter/material.dart';

import '../../models/args/chabbat.dart';

class TabTransactions extends StatelessWidget {
  ChabbatModel? chabbatResult;

  TabTransactions(this.chabbatResult, {Key? key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArgsChabbat;
    ChabbatModel _chabbat = args.chabbat;

    if (chabbatResult != null) {
      _chabbat = chabbatResult!;
    }

    return Center(
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                itemCount: _chabbat.transactions.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Text(
                          "${_chabbat.transactions[index].cost.toString()} ${_chabbat.currency!.symbol}"),
                      title: Text(_chabbat.transactions[index].name),
                      subtitle: Text(
                          idToName(_chabbat.transactions[index].user, context)),
                      trailing: IconButton(
                        icon: const Icon(Icons.description_outlined),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    // To allow flutter to load images from network, don't forget to setup CORS configuration by using google-cloud-sdk
                                    content: Image.network(
                                        _chabbat.transactions[index].image),
                                  ));
                        },
                      ),
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
