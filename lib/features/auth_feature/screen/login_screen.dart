import 'package:flutter/material.dart';
import 'package:sabthok/common/services/delayed_animation.dart';
import 'package:sabthok/common/widgets/custom_button.dart';
import 'package:sabthok/common/widgets/custom_text_filed.dart';
import 'package:sabthok/constants/global_variables.dart';
import 'package:sabthok/features/auth_feature/screen/signup_screen.dart';

import '../services/signup_signin_services.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final signInFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  signinUser() {
    AuthService().signInUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 70, left: 45, right: 45, bottom: 10),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                DelayedAnimation(
                  delay: 100,
                  child: Image.asset(
                    'assets/images/login_image.png',
                    // fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                DelayedAnimation(
                  delay: 100,
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.black54),
                  ),
                ),
                DelayedAnimation(
                  delay: 500,
                  child: Text(
                    'Please enter the credentials used to create your account',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Form(
                  key: signInFormKey,
                  child: Column(
                    children: [
                      DelayedAnimation(
                        delay: 300,
                        child: CustomTextField(
                          controller: emailController,
                          hintText: 'email',
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      DelayedAnimation(
                        delay: 250,
                        child: CustomTextField(
                          controller: passwordController,
                          hintText: 'password',
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 140,
                ),
                DelayedAnimation(
                  delay: 330,
                  child: CustomPrimaryButton(
                    text: 'Continue',
                    onTap: () {
                      if (signInFormKey.currentState!.validate()) {
                        signinUser();
                      }
                    },
                    color: GlobalVariables.primaryColor,
                  ),
                ),
                DelayedAnimation(
                  delay: 380,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Dont have an account?'),
                      CustomSecondaryButton(
                          textColor: GlobalVariables.testColor,
                          text: 'Register',
                          onTap: () {
                            Navigator.pushNamed(
                                context, SignUpScreen.routeName);
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
