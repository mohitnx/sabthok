import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/show_snackbar.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.body)['msg'], 0);

      break;

    case 500:
      showSnackBar(context, jsonDecode(response.body)['error'], 0);
      break;
    default:
      showSnackBar(context, response.body, 0);
  }
}
