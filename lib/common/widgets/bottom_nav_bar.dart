import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/global_variables.dart';
import '../../features/account/screens/account_screen.dart';
import '../../features/cart/screen/cart_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../provider/user_provider.dart';

class BottomNaviBar extends StatefulWidget {
  static const routeName = '/main-screen';
  const BottomNaviBar({super.key});

  @override
  State<BottomNaviBar> createState() => _BottomNaviBarState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  int _page = 0;
  double bottomNavBarWidth = 42;
  double bottomNavBarBorderWidth = 5;
  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];

  void updatePage(int pageNo) {
    setState(() {
      _page = pageNo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLength = context.watch<UserProvider>().user.cart.length;
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updatePage,
        currentIndex: _page,
        selectedItemColor: GlobalVariables.primaryColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.primaryColor
                        : GlobalVariables.backgroundColor,
                    width: bottomNavBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.home_outlined),
            ),
            label: '',
          ),
          //account
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.primaryColor
                        : GlobalVariables.backgroundColor,
                    width: bottomNavBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.person_outline),
            ),
            label: '',
          ),
          //cart
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? GlobalVariables.primaryColor
                        : GlobalVariables.backgroundColor,
                    width: bottomNavBarBorderWidth,
                  ),
                ),
              ),
              child: Badge(
                  elevation: 0,
                  badgeContent: Text(userCartLength.toString()),
                  badgeColor: Colors.white,
                  child: const Icon(Icons.shopping_cart_outlined)),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
