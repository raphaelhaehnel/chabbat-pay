import 'package:chabbat_pay/models/chabbat.dart';

class ArgsChabbat {
  final ChabbatModel chabbat;
  final Map<String, String> users;
  final bool menu;

  ArgsChabbat({
    required this.chabbat,
    required this.users,
    required this.menu,
  });

  ArgsChabbat.fromMap(Map<String, dynamic> args)
      : chabbat = args['chabbat'],
        users = args['users'],
        menu = args['menu'];
}
