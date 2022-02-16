import 'package:flutter/material.dart';
import './../items/user.dart';

class ListItems extends StatelessWidget {
  ListItems({Key? key, this.listItems = const []}) : super(key: key);

  final List<User> listItems;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        final item = listItems[index];

        return ListTile(
          title: Center(child: Text(item.name)),
          subtitle: Center(child: Text(item.credit.toString())),
        );
      },
      shrinkWrap: true,
    );
  }
}