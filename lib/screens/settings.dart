import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';
import 'package:stuk/authentication_service.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final picker = ImagePicker();
  File? imageFile;

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  Future uploadImage(BuildContext context, User firebaseUser) async {
    if (imageFile == null) return;
    String fileName = basename(imageFile!.path);

    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child('cards/$fileName');

    UploadTask uploadTask = ref.putFile(imageFile!);
    uploadTask.then((res) async {
      // Update user's cardimageurl in firestore
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      String imageURL = await res.ref.getDownloadURL();
      users.doc(firebaseUser.uid).update({'cardImageURL': imageURL});
      print('Image uploaded: $imageURL');
    });
  }

  Future<void> logout(BuildContext context) async {
    await context.read<AuthenticationService>().signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser == null) {
      Navigator.pushReplacementNamed(context, '/');
    }

    final fileName =
        imageFile != null ? basename(imageFile!.path) : 'No image chosen!';

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(height: 10.0),
          Text(
            'Upload image of card',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          OutlinedButton(
            child: const Text('Choose Image of Card'),
            onPressed: () async {
              await pickImage();
            },
          ),
          Container(
            child: imageFile != null
                ? Image.file(
                    imageFile!,
                    width: 400,
                    height: 200,
                    fit: BoxFit.fitHeight,
                  )
                : Text('No image selected'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
              primary: Colors.grey[900],
            ),
            onPressed: () async {
              await uploadImage(context, firebaseUser!);
            },
            child: const Text('Upload'),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                primary: Colors.redAccent,
              ),
              onPressed: () async {
                await logout(context);
              },
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}

class Navigation {
  static void pushReplacedName() {}
}
