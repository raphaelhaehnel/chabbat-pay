import 'package:chabbat_pay/models/args/chabbat.dart';
import 'package:flutter/material.dart';

String id_to_name(String id, context) {
  final args = ModalRoute.of(context)!.settings.arguments as ArgsChabbat;
  Map<String, String> usersMap = args.users;

  return usersMap[id]!;
}
