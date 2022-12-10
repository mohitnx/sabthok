import 'package:flutter/material.dart';

String uri = 'http://192.168.1.65:8000';

class GlobalVariables {
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 149, 36, 36),
      Color.fromARGB(255, 225, 137, 78),
    ],
    stops: [0.5, 1.0],
  );
  static const primaryColor = Color.fromARGB(223, 231, 64, 34);
  static const testColor = Color.fromARGB(255, 255, 210, 45);
  static const secondaryColor = Color.fromARGB(1, 34, 44, 34);
  static const backgroundColor = Colors.white;

  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;

  static const List<String> carouselImages = [
    'https://m.media-amazon.com/images/S/aplus-media-library-service-media/0fad4baf-d876-4c07-979a-f7fcb7548105.__CR0,0,970,600_PT0_SX970_V1___.jpg',
    'https://graphicsfamily.com/wp-content/uploads/edd/2022/08/Food-Menu-Instagram-Carousel-Design-scaled.jpg',
    'https://as2.ftcdn.net/v2/jpg/04/48/67/53/1000_F_448675378_GWliw5UHicv0NGXlPVJpogzm8i6H76T8.jpg',
    'https://m.media-amazon.com/images/S/aplus-media-library-service-media/be87dd20-8486-412d-8192-8dfe1830cd8f.__CR0,0,1464,600_PT0_SX1464_V1___.jpg',
    'https://m.media-amazon.com/images/S/aplus-media-library-service-media/0fad4baf-d876-4c07-979a-f7fcb7548105.__CR0,0,970,600_PT0_SX970_V1___.jpg',
  ];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'Vegetables',
      'image': 'assets/images/vegetables.jpg',
    },
    {
      'title': 'Fruits',
      'image': 'assets/images/fruits.jpg',
    },
    {
      'title': 'Fast Foods',
      'image': 'assets/images/fastfoods.jpg',
    },
    {
      'title': 'Recipe',
      'image': 'assets/images/recipes.jpg',
    },
    {
      'title': 'Snacks',
      'image': 'assets/images/snacks.jpg',
    },
  ];
}
