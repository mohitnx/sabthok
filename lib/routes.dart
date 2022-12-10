import 'package:flutter/material.dart';
import 'package:sabthok/features/auth_feature/screen/login_screen.dart';
import 'package:sabthok/features/auth_feature/screen/signup_screen.dart';

import 'common/widgets/bottom_nav_bar.dart';

import 'features/admin/screens/add_product_screen.dart';
import 'features/home/screens/category_deals_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/product_details/screens/product_details_screen.dart';
import 'features/search/screens/search_screen.dart';
import 'model/product.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );

    case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignUpScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        //we dont need builder so leave it
        builder: (_) => const HomeScreen(),
      );

    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        //we dont need builder so leave it
        builder: (_) => const AddProductScreen(),
      );

    case CategoryDealsScreen.routeName:
      //type of routeSettings is object, but our cateogry needes to be string, so we just use 'as String' or 'to String'
      var category = routeSettings.arguments.toString();
      return MaterialPageRoute(
        settings: routeSettings,
        //we dont need builder so leave it
        builder: (_) => CategoryDealsScreen(category: category),
      );

    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments.toString();
      return MaterialPageRoute(
        settings: routeSettings,
        //we dont need builder so leave it
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );

    case BottomNaviBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomNaviBar(),
      );

    case ProductDetailScreen.routeName:
      //treating obj as product, like mathi we treaed obj as string by using toString
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        //we dont need builder so leave it
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Such a page doesnot exist'),
          ),
        ),
      );
  }
}
