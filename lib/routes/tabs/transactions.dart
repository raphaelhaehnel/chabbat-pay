import 'package:chabbat_pay/models/chabbat.dart';
import 'package:flutter/material.dart';

class TabTransactions extends StatelessWidget {
  ChabbatModel? chabbatResult;

  TabTransactions(ChabbatModel? chabbatResult, {Key? key}) : super(key: key) {
    this.chabbatResult = chabbatResult;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    ChabbatModel _chabbat = args["chabbat"];

    if (chabbatResult != null) {
      _chabbat = chabbatResult!;
    }

    return Center(
      child: Column(
        children: [
          const Text("Participants"),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                itemCount: _chabbat.transactions.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading:
                          Text(_chabbat.transactions[index].cost.toString()),
                      title: Text(_chabbat.transactions[index].name),
                      subtitle: Text(_chabbat.transactions[index].user),
                      trailing: IconButton(
                        icon: const Icon(Icons.description_outlined),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  content: Image.asset(
                                      'images/PXL_20220801_130155821.jpg')));
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
