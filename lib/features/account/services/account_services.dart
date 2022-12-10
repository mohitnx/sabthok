import 'package:flutter/material.dart';
import 'package:sabthok/features/auth_feature/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/widgets/show_snackbar.dart';

void logOut(BuildContext context) async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('x-auth-token', '');
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.routeName,
      (route) => false,
    );
  } catch (e) {
    showSnackBar(context, e.toString(), 0);
  }
}
