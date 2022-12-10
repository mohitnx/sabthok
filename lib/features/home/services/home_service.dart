import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../common/services/error_handling.dart';
import '../../../common/widgets/show_snackbar.dart';
import '../../../constants/global_variables.dart';
import '../../../model/product.dart';
import '../../../provider/user_provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/products?category=$category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(), 0);
    }

    return productList;
  }

  Future<Product> fetchDealofTheDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    //here instead of empty product like Product? product, we instanciated a obj
    //why?
    //because
    //see deal of the day, weher we are checking if product==null then display Loader()
    //as discussed earleer in a similar situation, if we pass a null product from here
    //even after fetching product from this get request, if there is no value(suppose there are no produts listed, so ther won't be any deal of teh day), then null will be passed, if we do Produt? product
    //so loader will always be true
    //howeer
    //if we passs an actual object like this: then after the await fucn in deal of the day page,loader will show while awaiting,
    //then we will display an obj with empty anme, empty descp, epty imge and so on
    //so bascally an empty scaffold...so user kows there is no deal of the day
    Product product = Product(
        name: '',
        description: '',
        price: 0,
        quantity: 0,
        category: '',
        images: []);
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/deal-of-day'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          product = Product.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(), 0);
    }
//if there is no deal of the day, then
/* product = Product(
        name: '',
        description: '',
        price: 0,
        quantity: 0,
        category: '',
        images: []);*/
    // this is passed, which is not null, so after awaitign for teh fetching request, we won't have null,
    //we will have a product whoe name is empty, descripion is empty, etc
    //so loader wont' be displayed but an empty scaffold, so the user knows there is no deal of the day

    //if there is actual deal of the day then we return that , so after the await functio in deal fo the day page
    //we can display the product
    return product;
  }
}
