import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabthok/common/widgets/bottom_nav_bar.dart';
import 'package:sabthok/features/auth_feature/screen/login_screen.dart';
import 'package:sabthok/features/auth_feature/services/signup_signin_services.dart';
import 'package:sabthok/features/welcome_feature/screens/welcome_screen.dart';
import 'package:sabthok/provider/user_provider.dart';
import 'package:sabthok/routes.dart';

import 'constants/global_variables.dart';
import 'features/admin/screens/admin_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    ////////////////////////////////////////////////////////////////////////////////
    //without this we are not automaltical  routed to homescreen when there is logged in user
    ///////////////////////////////////////////////////////////////

    //super. means, first run initState original form that we get from the State(MyAppState), then tesko tala we can run
    //our functions as this is a override...see void initState ko mathi
    super.initState();
    //this func runs first
    AuthService().getUserData(context);
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SabThok',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            //whatever icons we use, they wll be of color black
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        //using on geenrate route gives us the ability to push custom logic/parse argument and send it alogn with the nameroute
        //which is not possible if we just use routes instead ongenerateroute
        onGenerateRoute: (settings) => generateRoute(settings),
        //token not empty means the user is logged in so show bottomvaibar, if empty means first time user..so login in scree

        home: Provider.of<UserProvider>(context).user.token.isNotEmpty
            ? Provider.of<UserProvider>(context).user.usertype == 'user'
                ? const BottomNaviBar()
                : const AdminScreen()
            : const WelcomeScreen());
  }
}
