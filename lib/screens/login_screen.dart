import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:stuk/authentication_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 100.0),
          Image(
            image: AssetImage('assets/images/stuk-logo.png'),
            width: MediaQuery.of(context).size.width * 0.6,
          ),
          SizedBox(height: 50.0),
          Text(
            'Login',
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          Container(
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email...',
              ),
            ),
            padding: EdgeInsets.all(10.0),
          ),
          Container(
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password...',
              ),
            ),
            padding: EdgeInsets.all(10.0),
          ),
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                primary: Colors.pinkAccent,
              ),
              onPressed: () {
                context.read<AuthenticationService>().signIn(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    );
              },
              child: Text('Login'),
            ),
            padding: EdgeInsets.all(10.0),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: Text(
              'Register account',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
