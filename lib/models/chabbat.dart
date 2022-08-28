import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chabbat_pay/models/transaction.dart';

class ChabbatModel {
  final String id;
  final String name;
  final bool open;
  final String admin;
  final List<String> usersId;
  final Timestamp date;
  final List<TransactionModel> transactions;

  ChabbatModel({
    this.id = 'UNDEFINED',
    this.name = 'UNDEFINED',
    this.open = false,
    this.admin = 'UNDEFINED',
    this.usersId = const <String>[],
    required this.date,
    this.transactions = const <TransactionModel>[],
  });

  ChabbatModel.fromMap(Map<String, dynamic> chabbat, String chabbatId)
      : id = chabbatId,
        name = chabbat['name'],
        open = chabbat['open'],
        admin = chabbat['admin'],
        usersId =
            (chabbat['users'] as List).map((user) => user as String).toList(),
        date = chabbat['date'],
        transactions = (chabbat['transactions'] as List)
            .map((transaction) => TransactionModel.fromMap(transaction))
            .toList();

  ChabbatModel addTransaction(TransactionModel transaction) {
    transactions.add(transaction);
    return this;
  }
}
