import 'package:chabbat_pay/models/args/chabbat.dart';
import 'package:flutter/material.dart';

/// Use the dictionnary of id's stored in the context to translate the id's to names
String idToName(String id, context) {
  final args = ModalRoute.of(context)!.settings.arguments as ArgsChabbat;
  Map<String, String> usersMap = args.users;

  return usersMap[id]!;
}
