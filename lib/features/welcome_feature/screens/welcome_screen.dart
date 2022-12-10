import 'package:flutter/material.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:sabthok/common/widgets/custom_button.dart';

import 'package:sabthok/constants/global_variables.dart';
import 'package:sabthok/features/auth_feature/screen/login_screen.dart';

import '../../auth_feature/screen/signup_screen.dart';
import '../../../common/services/delayed_animation.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  int delayedAmount = 600;
  double? _scale;
  AnimationController? _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const color = GlobalVariables.backgroundColor;

    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/welcome_background_image.jpg',
            ),
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 45, 0, 0),
                Color.fromARGB(223, 104, 25, 11).withOpacity(0.6),
                Color.fromARGB(236, 37, 6, 0).withOpacity(0.6),
                Color.fromARGB(238, 0, 0, 0),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  DelayedAnimation(
                    delay: delayedAmount + 300,
                    child: AvatarGlow(
                      endRadius: 120,
                      duration: const Duration(seconds: 5),
                      glowColor:
                          Color.fromARGB(179, 150, 72, 72).withOpacity(0.6),
                      repeat: true,
                      repeatPauseDuration: const Duration(seconds: 1),
                      startDelay: const Duration(seconds: 1),
                      child: CircleAvatar(
                        backgroundColor:
                            GlobalVariables.backgroundColor.withOpacity(.4),
                        radius: 60.0,
                        child: Image.asset(
                          'assets/splash_screen/sabthok.png',
                        ),
                      ),
                    ),
                  ),
                  DelayedAnimation(
                    delay: delayedAmount + 500,
                    child: Text(
                      "A one stop destination",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: color.withOpacity(0.5),
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  DelayedAnimation(
                    delay: delayedAmount + 500,
                    child: RichText(
                      text: TextSpan(
                        text: "for your every ",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: color.withOpacity(0.5),
                            fontStyle: FontStyle.italic),
                        children: [
                          const TextSpan(
                            text: "Culinary ",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.primaryColor,
                                fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                            text: "need",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: color.withOpacity(0.5),
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 350.0,
                  ),
                  DelayedAnimation(
                    delay: delayedAmount + 1000,
                    child: CustomPrimaryButton(
                      text: 'Get Started',
                      color: GlobalVariables.primaryColor,
                      onTap: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DelayedAnimation(
                      delay: delayedAmount + 1400,
                      child: CustomSecondaryButton(
                        text: 'I Have An Account',
                        onTap: () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                        color: GlobalVariables.secondaryColor,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
