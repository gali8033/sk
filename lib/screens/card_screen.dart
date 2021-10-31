import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:stuk/components/card_flipper.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CardScreen extends StatefulWidget {
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  String bottomBarImage = 'assets/images/bottom-bar-big.png';
  String card = 'assets/images/card-front-example.png';

  void onCardChange() {
    // setState(() {
    //   if (bottomBarImage == 'assets/images/bottom-bar-second-color-big.png') {
    //     bottomBarImage = 'assets/images/bottom-bar-first-color-big.png';
    //   } else {
    //     bottomBarImage = 'assets/images/bottom-bar-second-color-big.png';
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser == null) {
      Navigator.pushReplacementNamed(context, '/');
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/card-background.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(height: 50),
                    CardFlipper(
                      network: snapshot.requireData['cardImageURL'] != null
                          ? true
                          : false,
                      cardFront: snapshot.requireData['cardImageURL'] ?? card,
                      cardBack: 'assets/images/card-flipped.png',
                    ),
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(bottomBarImage),
                        ),
                      ),
                      width: double.infinity,
                      height: 80.0,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: Text(''),
                            style: TextButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
