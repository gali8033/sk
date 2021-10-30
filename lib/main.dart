import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuk/authentication_service.dart';
import 'package:stuk/screens/register_screen.dart';
import 'package:stuk/screens/start.dart';
import 'package:stuk/screens/card_screen.dart';
import 'package:stuk/screens/settings.dart';
import 'package:stuk/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => AuthenticationWrapper(),
            '/settings': (context) => Settings(),
            '/card': (context) => CardScreen(),
            '/register': (context) => RegisterScreen(),
          }),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      print(firebaseUser.uid);
      return Start();
    }

    return LoginScreen();
  }
}
