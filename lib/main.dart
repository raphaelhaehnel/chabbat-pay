import 'package:chabbat_pay/routes/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './routes/home.dart';
import './routes/profile.dart';
import 'package:flutter_login/flutter_login.dart';
import './services/auth.dart';

void main() async {
  await initializeDefault();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
          home: Wrapper(),
          title: 'Named Routes Demo',
          // initialRoute: '/',
          // routes: {
          //   '/': (context) => LoginScreen(),
          //   '/home': (context) => const RouteHome(),
          //   '/profile': (context) => RouteProfile(),
          // },
          theme: myAppTheme()),
    );
  }
}

// Test
myAppTheme() {
  return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.amber,
      fontFamily: 'Georgia');
}

const users = const {
  'raphael@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 100);

  final AuthService _auth = AuthService();

  Future<String?> _authUser(LoginData data) async {
    // debugPrint('Name: ${data.name}, Password: ${data.password}');
    // return Future.delayed(loginTime).then((_) {
    //   if (!users.containsKey(data.name)) {
    //     return 'User not exists';
    //   }
    //   if (users[data.name] != data.password) {
    //     return 'Password does not match';
    //   }
    //   return null;
    // });
    dynamic result = await _auth.signInEmail(data.name, data.password);
    if (result == null) {
      return result.toString();
    } else {
      print('User id: ${result.uid}');

      // Return null to validate authentication
      return null;
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    // debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    // return Future.delayed(loginTime).then((_) {
    //   return null;
    // });
    dynamic result = await _auth.signUpEmail(data.name, data.password);
    return result.toString();
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'PayYourChabess!',
      logo: AssetImage('images/logo-transparent.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => RouteProfile(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}

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
