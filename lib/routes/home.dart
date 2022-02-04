import 'package:flutter/material.dart';
import '../components/menu.dart';
import '../items/user.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, DbCollection;

// class RouteHome extends StatelessWidget {
//   const RouteHome({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Messages'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           children: [],
//         ),
//       ),
//       drawer: const MenuApp(),
//     );
//   }
// }

class RouteHome extends StatefulWidget {
  const RouteHome({Key? key}) : super(key: key);

  @override
  State<RouteHome> createState() => _RouteHomeState();
}

class _RouteHomeState extends State<RouteHome> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String test = "null";
  List<User> listItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter a name',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      test = value;
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          // Process data.
                          if (test != null) {
                            listItems.add(User(credit: 0, name: test));
                          }
                        }
                      },
                      child: const Text('Add participant'),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              itemCount: listItems.length,
              itemBuilder: (context, index) {
                final item = listItems[index];

                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.credit.toString()),
                );
              },
            )
          ],
        ),
      ),
      drawer: MenuApp(arguments: listItems),
    );
  }
}
