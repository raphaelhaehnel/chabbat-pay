import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChabbatModel {
  final String id;
  final String name;
  final bool open;
  final String admin;
  final Map<String, dynamic> users;
  final Timestamp date;

  ChabbatModel({
    this.id = 'UNDEFINED',
    this.name = 'UNDEFINED',
    this.open = false,
    this.admin = 'UNDEFINED',
    this.users = const {},
    required this.date,
  });

  ChabbatModel.fromMap(Map<String, dynamic> chabbat, String chabbatId)
      : id = chabbatId,
        name = chabbat['name'],
        open = chabbat['open'],
        admin = chabbat['admin'],
        users = chabbat['users'],
        date = chabbat['date'];
}
