import 'package:chabbat_pay/firebase_options.dart';
import 'package:chabbat_pay/routes/chabbat.dart';
import 'package:chabbat_pay/routes/chabbat_history.dart';
import 'package:chabbat_pay/routes/join_chabbat.dart';
import 'package:chabbat_pay/routes/login_redirection.dart';
import 'package:chabbat_pay/routes/new_chabbat.dart';
import 'package:chabbat_pay/routes/new_transaction.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './routes/home.dart';
import './routes/profile.dart';
import 'package:flutter_login/flutter_login.dart';
import './services/auth.dart';

void main() async {
  await initializeDefault();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
            '/profile/history': (context) => const RouteChabbatHistory(),
            '/home/new': (context) => const RouteNewChabat(),
            '/home/join': (context) => RouteJoinChabat(),
            '/chabbat': (context) => const RouteChabbat(),
            '/chabbat/new_transaction': (context) =>
                const RouteNewTransaction(),
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
  LoginScreen({Key? key}) : super(key: key);

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
      return "Cannot sign in. Please try again";
    } else {
      // Return null to validate authentication
      return null;
    }
  }

  Future<String?> _recoverPassword(String email) async {
    String? result = _auth.resetPassword(email);
    if (result != null) {
      return result;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'PayYourChabess!',
      logo: 'assets/images/logo-transparent.png',
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
  if (kDebugMode) {
    print('Initialized default app $app');
  }
}
