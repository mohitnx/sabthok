import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/services/error_handling.dart';
import '../../../common/widgets/show_snackbar.dart';
import '../../../constants/global_variables.dart';
import '../../../model/product.dart';
import '../../../model/user_model.dart';
import '../../../provider/user_provider.dart';

class ProductDetailsServices {
  addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          //we didnt' just update the user and instead created a new user with same properties as old user but with new value in cart property
          //because if we update user, then we have to go back to auth screen as proeprties are updated? and so on...reason I'm also not sure
          //maybe try updating instead of copyWith in your own app, Rivaan said updting will cause erros in authenticating,, etc
          //so better way would be to create a new user with copyWith
          User user =
              //all same values except for cart
              //cart ko value comes from http request ko response, and since we just want cart we can just decode that instead of whole body decoding
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(), 0);
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
          'rating': rating,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      showSnackBar(context, e.toString(), 0);
    }
  }
}
