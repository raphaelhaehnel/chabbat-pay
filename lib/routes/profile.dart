import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../components/menu.dart';
import '../items/user.dart';
import '../components/listItems.dart';
import '../components/my_button.dart';

class RouteProfile extends StatelessWidget {
  const RouteProfile({Key? key}) : super(key: key);

  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp(
        name: "myFirebase", options: firebaseOptions);
    print('Initialized default app $app');
  }

  FirebaseOptions get firebaseOptions => const FirebaseOptions(
      apiKey: "AIzaSyD9bvtsRsrmwgi9RuVy9ynCzCvYFd9D-jU",
      authDomain: "payetonchabbat-1570735814576.firebaseapp.com",
      projectId: "payetonchabbat-1570735814576",
      storageBucket: "payetonchabbat-1570735814576.appspot.com",
      messagingSenderId: "1093457557540",
      appId: "1:1093457557540:web:b5ef3e1bd352959b3ac0b1",
      measurementId: "G-0VB8WWZLC5");

  @override
  Widget build(BuildContext context) {
    // Load the argument from the route
    // final args = ModalRoute.of(context)!.settings.arguments as User;

    List<User> listItems = [];
    if (ModalRoute.of(context)!.settings.arguments != null) {
      listItems = ModalRoute.of(context)!.settings.arguments as List<User>;
    }

    initializeDefault();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(
        children: [ListItems(listItems: listItems), const myButton()],
      ),
      drawer: MenuApp(arguments: listItems),
    );
  }
}
