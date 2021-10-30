import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:stuk/authentication_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final error = errorMessage.length > 0 ? errorMessage : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 50.0),
          Image(
            image: AssetImage('assets/images/stuk-logo.png'),
            width: MediaQuery.of(context).size.width * 0.6,
          ),
          SizedBox(height: 50.0),
          Text(
            'Register',
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          Container(
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email...',
              ),
            ),
            padding: EdgeInsets.all(10.0),
          ),
          Container(
            child: TextField(
              controller: passwordController,
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
            child: TextField(
              controller: confirmPasswordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password...',
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
              onPressed: () async {
                setState(() => errorMessage = '');
                String email = emailController.text.trim();
                String password1 = passwordController.text.trim();
                String password2 = confirmPasswordController.text.trim();

                if (email.length == 0 ||
                    password1.length == 0 ||
                    password2.length == 0) {
                  setState(() {
                    errorMessage = 'Please enter all fields!';
                  });
                  return;
                }

                if (password1 != password2) {
                  setState(() {
                    errorMessage = 'Passwords don\'t match!';
                  });
                  return;
                }

                try {
                  // Perform sign up
                  String uid =
                      await context.read<AuthenticationService>().signUp(
                            email: email,
                            password: password1,
                          );

                  // Add to users collection
                  CollectionReference users =
                      FirebaseFirestore.instance.collection('users');
                  users
                      .doc(uid)
                      .set({
                        'uid': uid,
                        'email': email,
                        'cardImageURL': '',
                        'created': DateTime.now(),
                      })
                      .then((value) => print('User added'))
                      .catchError((error) => print('Error adding user'));

                  Navigator.pop(context);
                } on Exception catch (e) {
                  print(e);
                }
              },
              child: Text('Register'),
            ),
            padding: EdgeInsets.all(10.0),
          ),
          TextButton(
            onPressed: () {
              print('RegisterButton pressed');
            },
            child: Text(
              'Register account',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Text(
            error,
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
