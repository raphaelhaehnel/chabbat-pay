import 'package:flutter/material.dart';

class JoinChabatRoute extends StatelessWidget {
  const JoinChabatRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join a chabbat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Type de chabbat code here',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () => {}, child: const Text('OK')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
