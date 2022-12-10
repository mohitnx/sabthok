import 'dart:convert';

class User {
  final String email;
  final String id;
  final String name;
  final String password;
  final String? usertype;
  final String address;
  final String token;
  final List<dynamic> cart;

  User({
    required this.email,
    required this.id,
    required this.name,
    required this.password,
    this.usertype = 'user',
    required this.address,
    required this.token,
    required this.cart,
  });

//for sending requests
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'id': id,
      'name': name,
      'password': password,
      'address': address,
      'type': usertype,
      'token': token,
      'cart': cart,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

//for getting results from api and instanciating class obj from them

//factory isn't exactly a contructor, it is a fucn that calls a construcotr after some logic so
//use factor over normal constructor, as in factory constructor, we can manipulate the incoming data, before
//calling a normal constructor and assigning values to create a class obj

//from docs:
/**Another use case for factory constructors is initializing a final variable using logic that can’t be handled in the initializer list. */

//to check remove factory keyword and see what happens

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      id: map['_id'],
      name: map['name'],
      password: map['password'],
      usertype: map['type'],
      address: map['address'],
      token: map['token'],
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }

  User copyWith({
    String? email,
    String? id,
    String? name,
    String? password,
    String? type,
    String? address,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      email: email ?? this.email,
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      usertype: type ?? this.usertype,
      address: address ?? this.address,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
