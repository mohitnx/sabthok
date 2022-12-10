import 'package:flutter/material.dart';

import 'package:sabthok/features/auth_feature/screen/login_screen.dart';
import 'package:sabthok/features/auth_feature/services/signup_signin_services.dart';

import '../../../common/services/delayed_animation.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_filed.dart';
import '../../../constants/global_variables.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup-screen';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final signUpFormKey = GlobalKey<FormState>();
  String selectedUserType = 'user';
  List<String> userType = ['user', 'admin'];
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();

    addressController.dispose();
  }

  signupUser() {
    AuthService().signUpUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      address: addressController.text,
      type: selectedUserType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40, left: 45, right: 45, bottom: 10),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -20,
                right: -25,
                child: DelayedAnimation(
                  delay: 200,
                  child: Container(
                    height: 250,
                    child: Image.asset(
                      'assets/images/signup_image.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  DelayedAnimation(
                    delay: 300,
                    child: Text(
                      "Let's Get You Started",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: Colors.black54),
                    ),
                  ),
                  DelayedAnimation(
                    delay: 500,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'This will only take a few seconds',
                        style: TextStyle(color: Colors.black45),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Form(
                    key: signUpFormKey,
                    child: Column(
                      children: [
                        DelayedAnimation(
                          delay: 320,
                          child: CustomTextField(
                            bordercolor: GlobalVariables.testColor,
                            controller: nameController,
                            hintText: 'Name',
                          ),
                        ),
                        DelayedAnimation(
                          delay: 380,
                          child: CustomTextField(
                            bordercolor: GlobalVariables.testColor,
                            controller: emailController,
                            hintText: 'Email',
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DelayedAnimation(
                          delay: 400,
                          child: CustomTextField(
                            bordercolor: GlobalVariables.testColor,
                            controller: passwordController,
                            hintText: 'Password',
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DelayedAnimation(
                          delay: 440,
                          child: CustomTextField(
                            bordercolor: GlobalVariables.testColor,
                            controller: addressController,
                            hintText: 'Address',
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        DelayedAnimation(
                          delay: 480,
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Almost there! Please select your account type',
                                style: TextStyle(color: Colors.black45),
                              )),
                        ),
                        DelayedAnimation(
                          delay: 520,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            width: double.infinity,
                            child: DropdownButton<String>(
                              borderRadius: BorderRadius.circular(20),
                              isExpanded: true,
                              focusColor: GlobalVariables.testColor,
                              hint: Text('Account Type'),
                              value: selectedUserType,
                              items: userType
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          width: 70,
                                          decoration: const BoxDecoration(
                                            color: GlobalVariables.testColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15.0),
                                            ),
                                          ),
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                                color: GlobalVariables
                                                    .backgroundColor),
                                          )),
                                    ),
                                  )
                                  .toList(),
                              onChanged: ((value) => setState(
                                    () {
                                      selectedUserType = value!;
                                    },
                                  )),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              underline: SizedBox(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        DelayedAnimation(
                          delay: 440,
                          child: CustomPrimaryButton(
                            text: 'Register',
                            onTap: () {
                              if (signUpFormKey.currentState!.validate()) {
                                signupUser();
                              }
                            },
                            color: GlobalVariables.testColor,
                          ),
                        ),
                        DelayedAnimation(
                          delay: 500,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already a user?'),
                                CustomSecondaryButton(
                                    text: 'Login',
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, LoginScreen.routeName);
                                    })
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
