import 'package:chabbat_pay/routes/chabbat.dart';
import 'package:chabbat_pay/routes/chabbat_history.dart';
import 'package:chabbat_pay/routes/join_chabbat.dart';
import 'package:chabbat_pay/routes/login_redirection.dart';
import 'package:chabbat_pay/routes/new_chabbat.dart';
import 'package:chabbat_pay/routes/new_transaction.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './routes/home.dart';
import './routes/profile.dart';
import 'package:flutter_login/flutter_login.dart';
import './services/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await initializeDefault();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      // Initialize the AuthService
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
          title: 'Named Routes Demo',
          initialRoute: '/',
          routes: {
            '/': (context) => LoginScreen(),
            '/home': (context) => const RouteHome(),
            '/profile': (context) => RouteProfile(),
            '/profile/history': (context) => RouteChabbatHistory(),
            '/home/new': (context) => RouteNewChabat(),
            '/home/join': (context) => RouteJoinChabat(),
            '/chabbat': (context) => RouteChabbat(),
            '/chabbat/new_transaction': (context) => RouteNewTransaction(),
            '/login_redirection': (context) => LoginRedirection(),
          },
          theme: myAppTheme()),
    );
  }
}

// Test
myAppTheme() {
  return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blueGrey,
      fontFamily: 'Georgia');
}

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 100);

  final AuthService _auth = AuthService();

  Future<String?> _authUser(LoginData data) async {
    dynamic result = await _auth.signInEmail(data.name, data.password);
    if (result == null) {
      return "The password is invalid or the user does not have a password";
    } else {
      // Return null to validate authentication
      return null;
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    dynamic result = await _auth.signUpEmail(data.name, data.password);
    if (result == null) {
      return result.toString();
    } else {
      // Return null to validate authentication
      return null;
    }
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (true) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'PayYourChabess!',
      logo: const AssetImage('images/logo-transparent.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacementNamed(
          context,
          '/login_redirection',
        );
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}

// Initialize the Firebase module
Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp(
      name: "myFirebase", options: firebaseOptions);
  print('Initialized default app $app');
}

// Authentification parameters of Firebase
FirebaseOptions get firebaseOptions => FirebaseOptions(
    apiKey: dotenv.env['API_KEY']!,
    authDomain: "payetonchabbat-1570735814576.firebaseapp.com",
    projectId: "payetonchabbat-1570735814576",
    storageBucket: "payetonchabbat-1570735814576.appspot.com",
    messagingSenderId: "1093457557540",
    appId: "1:1093457557540:web:b5ef3e1bd352959b3ac0b1",
    measurementId: "G-0VB8WWZLC5");
