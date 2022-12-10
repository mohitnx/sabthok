import 'dart:convert';

import 'package:sabthok/model/rating.dart';

//dart:html only works on web, and creates error if used in mobile platform
class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final double quantity;
  final String category;
  final List<String> images;
  final List<Rating>? rating;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.images,
    this.rating,
    this.id,
  });
//we wrote code below this using the bulb button and json serialtion which comes form Dart Data class generator
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'images': images,
      'rating': rating,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'].toDouble(),
      quantity: map['quantity'].toDouble(),
      category: map['category'] ?? '',
      images: List<String>.from(
        (map['images']),
      ),
      //js model schema ma we have ratings so use ratings here, we we are getting that and converting it to Product obj
      //if ratings not null, then do 'this' other do nothign
      //this:
      //.from creates a new list from given list
      //here .from ko kaam: creates a list of type Rating(of dart) from the list(map['ratings']) ...
      //map['ratings'] will be given from json after decode, which will have ratings.js mmodel ko elements so it will have multiple (userId, ratings)
      //so we create a new dart list with thoses elemnts, and since it is a list, we can map each element of that list
      //to be class objects of Rating model of dart, through fromMap function [ (x)=>Rarings.fromMap(x)], just like mathi we have Product.fromMap to craet product objects from json
      //and maps each element as an object of Rating class of dart

      //esto tarkia le garda paryo as map['ratings'] is a array/list of ratingsSchema which in turn is a class/object of userId and ratings (see product.js model and rating.js model),
      //rating: (dart ko) is a List of RAting class, so tyo data type mmilauna, paila we get rating from js, then map throrugh each of its elements which is on type ratingSchema, so that it can be stored in its correct way
      rating: map['ratings'] != null
          ? List<Rating>.from(
              map['ratings']?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
