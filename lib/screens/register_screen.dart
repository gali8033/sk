import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:stuk/authentication_service.dart';

String getMessageFromErrorCode(error) {
  switch (error) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "Email already used. Go to login page.";
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "Wrong email/password combination.";
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "No user found with this email.";
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "User disabled.";
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      return "Too many requests to log into this account.";
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      return "Server error, please try again later.";
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "Email address is invalid.";
    case "ERROR_WEAK_PASSWORD":
    case "weak-password":
      return "Too weak password.";
    default:
      return "Register failed. Please try again.";
  }
}

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
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    errorMessage = getMessageFromErrorCode(e.code);
                  });
                } catch (e) {
                  print(e);
                  setState(() {
                    errorMessage =
                        'Something went wrong, please try again later!';
                  });
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
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
