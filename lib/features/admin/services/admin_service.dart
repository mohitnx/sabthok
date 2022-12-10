import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../common/services/error_handling.dart';
import '../../../common/widgets/show_snackbar.dart';
import '../../../constants/global_variables.dart';
import '../../../model/product.dart';
import '../../../provider/user_provider.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('dbrufm8j1', 'knqf0qeh');
      List<String> imageUrls = [];
      //just copied from pubdev
      //just copied from pubdev(folder parth added extra)
      for (int i = 0; i < images.length; i++) {
        //.uploadfILE takes a cloudinaryFIle.fromfile(path)
        //path is the path of our images
        //instead of fromFile there are various other options like from url, from byte, etc
        //we have FILE so we use that

        //we are adding folder to create some management, otherwise, cloudinary will just store images contiuousnly
        //folder gives the storage some structure
        CloudinaryResponse res = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));
        //seureUrl is property of CloudinarREsponse obj
        //we only upload these urls as strings to the mongodb and the actual image that url represnts is stored in cloudinary as images
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        category: category,
        images: imageUrls,
      );
      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );
      showSnackBar(context, 'Product added successfully', 1);
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Product added successfully', 1);
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(context, e.toString(), 0);
    }
  }

  //getting all products

//we receive a json from mongoose after we make the ps ot erquest, which consists of hte name, iamge, category, id, etc
//we can use that response here parse it form json and put it ino our Producct dart class
//so Product dart class converted to json while sending/post,
//and json decoded back to Product class obj to veiw in clinet side
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      //res.body after decoding is a lsit here not a map, as we get a list of product from server side
      http.Response res = await http.get(Uri.parse('$uri/admin/get-products'),
          //for authentication, we have to pass headers, and since this is a get req, to get all teh list of products,
          //we don't need to pass any body, the get req itself is implemented to give all the products
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          });
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          //prints 8. so no problem upton here
          print(jsonDecode(res.body).length);

          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            //we are calling fromJson on each list item, to use [i], we need a list i.e json should be decoded, but
            //fromJson takes a string, so what we are doing is first jsonDecode[i], so that we have one item
            //then we are endocing again so that we can take that itme and put it as a Product class obj using froJson()
            //and the reason jsonEncode is needed is because fromJson takes a string not a list which we get from jsonDecode (we get an object form jsonDecode, which can be list/map,etc)...so encode is jsut acting as a middle man
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

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        //withoutJsonencode, its just a map, after encoding it becomes a json, and we can send it//
        //as we need id to delete(in server side) we are sending just id
        body: jsonEncode({'id': product.id}),
      );
      showSnackBar(context, 'Deleted Successfully', 1);

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            onSuuccess();
          });
    } catch (e) {
      showSnackBar(context, e.toString(), 0);
    }
  }
}
