import 'package:chabbat_pay/components/menu.dart';
import 'package:chabbat_pay/models/args/chabbat.dart';
import 'package:chabbat_pay/models/chabbat.dart';
import 'package:chabbat_pay/routes/tabs/balance.dart';
import 'package:chabbat_pay/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:chabbat_pay/routes/tabs/overview.dart';
import 'package:chabbat_pay/routes/tabs/transactions.dart';

class RouteChabbat extends StatefulWidget {
  const RouteChabbat({Key? key}) : super(key: key);

  @override
  State<RouteChabbat> createState() => _RouteChabbatState();
}

class _RouteChabbatState extends State<RouteChabbat> {
  final AuthService _auth = AuthService();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    const TabOverview(),
    TabTransactions(null),
    const TabBalance(),
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

    if (ModalRoute.of(context)!.settings.arguments == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        Navigator.pushReplacementNamed(
          context,
          '/home',
        );
      });
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final args = ModalRoute.of(context)!.settings.arguments as ArgsChabbat;

    ChabbatModel _chabbat = args.chabbat;
    Map<String, String> _users = args.users;
    bool _menu = args.menu;

    // TODO: Pas besoin de ca
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
            icon: Icon(Icons.attach_money),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Balance',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/chabbat/new_transaction',
                  arguments: {"chabbat": _chabbat, "menu": false},
                ) as ChabbatModel;

                setState(() {
                  _widgetOptions[1] = TabTransactions(result);
                });
              },
              child: const Icon(Icons.add_shopping_cart),
            )
          : null,
    );
  }
}
