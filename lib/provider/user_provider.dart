import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sabthok/model/user_model.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    email: '',
    id: '',
    name: '',
    password: '',
    usertype: '',
    address: '',
    token: '',
    cart: [],
  );

//when we just pass res.body then res.body is string so we use this to set user
//just use ctrl+clk on the functio to see where it has been used
  User get user => _user;
  void setUser(String user) {
    _user = User.fromJson(jsonDecode(user));
    notifyListeners();
  }

//when we have already decoded the json and have a User object, then we use this to set the user
  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
