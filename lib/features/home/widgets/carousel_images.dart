import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sabthok/constants/global_variables.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});
//carousel has infinte scroll loop...for this app, that is its adv over listview
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: GlobalVariables.carouselImages.map((i) {
        return Image.network(
          i,
          fit: BoxFit.cover,
          height: 200,
        );
      }).toList(),
      options: CarouselOptions(
        //all images will follow this height and veiwportFraction
        //viewportFraction is betnw 0-1, 1 means whole viewport/screen
        viewportFraction: 1,
        height: 200,
      ),
    );
  }
}
