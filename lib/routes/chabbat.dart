import 'package:chabbat_pay/components/menu.dart';
import 'package:chabbat_pay/models/chabbat.dart';
import 'package:chabbat_pay/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteChabbat extends StatefulWidget {
  RouteChabbat({Key? key}) : super(key: key);

  @override
  State<RouteChabbat> createState() => _RouteChabbatState();
}

class _RouteChabbatState extends State<RouteChabbat> {
  final AuthService _auth = AuthService();

  CollectionReference chabbatsCollection =
      FirebaseFirestore.instanceFor(app: Firebase.app('myFirebase'))
          .collection('chabbats');

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    const TabOverview(),
    const TabTransactions(),
    const Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Load the authenticated user from the provider
    User? _user = Provider.of<User?>(context);

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    ChabbatModel _chabbat = args["chabbat"];
    bool _menu = args["menu"];

    return Scaffold(
      appBar: AppBar(
        title: Text('Chabbat ${_chabbat.name}'),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: const Icon(Icons.person),
              label: const Text('Logout'),
              style: TextButton.styleFrom(primary: Colors.grey[800])),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      drawer: _menu ? const MenuApp() : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class TabOverview extends StatelessWidget {
  const TabOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    ChabbatModel _chabbat = args["chabbat"];

    return Center(
      child: Column(
        children: [
          const Text("Participants"),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                itemCount: _chabbat.users.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_chabbat.users.keys.elementAt(index)),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabTransactions extends StatelessWidget {
  const TabTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    ChabbatModel _chabbat = args["chabbat"];

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Text('${_chabbat.open}'),
            ],
          ),
        ));
  }
}
