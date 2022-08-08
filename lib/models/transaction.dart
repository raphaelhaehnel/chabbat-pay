import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String name;
  final String user;
  final String image;
  final double cost;
  final Timestamp date;

  TransactionModel({
    required this.name,
    required this.user,
    required this.image,
    required this.cost,
    required this.date,
  });

  TransactionModel.fromMap(Map<String, dynamic> transaction)
      : name = transaction['name'],
        user = transaction['user'],
        image = transaction['image'],
        cost = transaction['cost'],
        date = transaction['date'];

  toMap() {
    return {
      'name': name,
      'user': user,
      'image': image,
      'cost': cost,
      'date': date,
    };
  }
}
