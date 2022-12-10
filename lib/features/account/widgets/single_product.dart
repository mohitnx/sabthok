import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  String src;
  SingleProduct({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1.5),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(10),
          //it will fit based on the max height the image can take
          //img width is 180, and height BoxFit.fitHeight so img will take max height it can get from its parent that is a container
          child: Image.network(
            src,
            width: 180,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
