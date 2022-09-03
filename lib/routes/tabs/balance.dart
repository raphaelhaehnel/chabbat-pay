import 'package:chabbat_pay/models/args/chabbat.dart';
import 'package:chabbat_pay/models/chabbat.dart';
import 'package:chabbat_pay/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:chabbat_pay/utilities/id_to_user.dart';

class TabBalance extends StatelessWidget {
  const TabBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArgsChabbat;
    ChabbatModel _chabbat = args.chabbat;
    Map<String, double> _balance = {
      for (String singleUser in _chabbat.usersId) singleUser: 0.0
    };

    double _totalChabbat = 0.0;
    int _N = _chabbat.usersId.length;

    for (TransactionModel transaction in _chabbat.transactions) {
      if (_balance[transaction.user] == null) {
        throw Exception("The owner of the transaction does not exists");
      } else {
        _balance[transaction.user] =
            _balance[transaction.user]! + transaction.cost;
        _totalChabbat += transaction.cost;
      }
    }

    var _result =
        _balance.map((key, value) => MapEntry(key, _totalChabbat / _N - value));

    return Center(
      child: Column(
        children: [
          Text(
              "Total chabbat: ${_totalChabbat.toStringAsFixed(2)} ${_chabbat.currency!.symbol}"),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                itemCount: _result.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                          idToName(_result.keys.elementAt(index), context)),
                      trailing: Text(
                          "${_result.values.elementAt(index).toString()} ${_chabbat.currency!.symbol}"),
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
