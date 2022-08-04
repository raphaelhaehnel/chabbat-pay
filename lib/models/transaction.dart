import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String name;
  final String user;
  final String image;
  final int cost;
  final Timestamp date;

  TransactionModel({
    this.name = 'UNDEFINED',
    this.user = 'UNDEFINED',
    this.image = 'UNDEFINED',
    this.cost = -1,
    required this.date,
  });

  TransactionModel.fromMap(Map<String, dynamic> transaction)
      : name = transaction['name'],
        user = transaction['user'],
        image = transaction['image'],
        cost = transaction['cost'],
        date = transaction['date'];
}
