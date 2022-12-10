import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sabthok/constants/global_variables.dart';
import 'package:sabthok/features/auth_feature/screen/login_screen.dart';
import 'package:sabthok/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/services/error_handling.dart';
import '../../../common/widgets/bottom_nav_bar.dart';
import '../../../common/widgets/show_snackbar.dart';
import '../../../provider/user_provider.dart';

class AuthService {
  //singup user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String address,
    required String type,
  }) async {
    try {
      User user = User(
        email: email,
        name: name,
        password: password,
        address: address,
        usertype: type,
        id: '',
        token: '',
        cart: [],
      );

      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context,
                'Account has beeen created. Now login with the same credentials',
                1);

            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.routeName, (route) => false);
          });
    } catch (e) {
      showSnackBar(context, e.toString(), 0);
    }
  }

//signin user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['token']);
            Navigator.pushNamedAndRemoveUntil(
                context, BottomNaviBar.routeName, (route) => false);
          });
    } catch (e) {
      showSnackBar(context, e.toString(), 0);
    }
  }

  //getting user
  void getUserData(
    BuildContext context,
  ) async {
    try {
      //shardPrefeence is a map or key/value pair that stores limited info in the device sotreage

      //getting shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //getString gets us the value(our value is stirng so getString used, for bool we can use getBool and so on, same for setString, getInt, getBool etc)
      //if there is no value  null is returned, so String? used
      //'x-auth-token is the key, when we do getString, we get the vlaue associated with that key

      String? token = prefs.getString('x-auth-token');
      if (token == null) {
        //if the user has used the app for the first time, he won't have a token so , we keep the token empty
        //x-auth-token is the key and ' ' is the value, so we can get  ' ' by accsesing x-auth-key
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http
          .post(Uri.parse('$uri/tokenIsValid'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        //sending the token in header, so that uta auth.js ma we can access it by res.header('x-auth-token) and check for verification

        //we send value of token in 'x-auth-token', and based on the response (if true then we show user data other wise we go to logn/signup page
        'x-auth-token': token!
      });

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        //get user data
        http.Response userRes = await http.get(Uri.parse('$uri/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            });
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString(), 0);
    }
  }
}
