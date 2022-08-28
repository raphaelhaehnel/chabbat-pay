import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String route;
  final String name;
  const HomeButton({required this.route, required this.name, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
                  context,
                  route,
                ),
            child: Text(name)),
        width: 180,
      ),
    );
  }
}
