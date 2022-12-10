import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabthok/constants/global_variables.dart';

import '../../../common/services/error_handling.dart';
import '../../../common/widgets/show_snackbar.dart';
import '../../../model/product.dart';
import '../../../model/user_model.dart';
import '../../../provider/user_provider.dart';
import 'package:http/http.dart' as http;

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          //as said while updaintg ratings, it is easier to create new user than to update due to authenctiona, etc etc
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          //proivder class ma explained, when to use setUser and when to use setUserfromModel
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(), 0);
    }
  }
}
