import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class CardFlipper extends StatelessWidget {
  String cardFront;
  String cardBack;
  bool network;

  CardFlipper(
      {required this.cardFront, required this.cardBack, required this.network});

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill.fillBack,
      direction: FlipDirection.HORIZONTAL, // default
      front: Container(
        child: RotatedBox(
          quarterTurns: 1,
          child: Container(
            width: MediaQuery.of(context).size.width * 1.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: (network
                    ? NetworkImage(cardFront)
                    : AssetImage(cardFront)) as ImageProvider,
              ),
            ),
          ),
        ),
      ),
      back: Container(
        child: Container(
          width: MediaQuery.of(context).size.width * 1.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(cardBack),
            ),
          ),
        ),
      ),
    );
  }
}
