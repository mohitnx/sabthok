import 'package:flutter/material.dart';
import 'package:sabthok/features/admin/screens/analytics_screen.dart';
import 'package:sabthok/features/admin/screens/orders_screen.dart';
import 'package:sabthok/features/admin/screens/post_screen.dart';

import '../../../constants/global_variables.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;
  double bottomNavBarWidth = 42;
  double bottomNavBarBorderWidth = 5;

  List<Widget> pages = [
    Padding(
      padding: const EdgeInsets.all(11.0),
      child: const PostsScreen(),
    ),
    Padding(padding: EdgeInsets.all(12), child: AnalyticsScreen()),
    OrdersScreen(),
  ];

  void updatePage(int pageNo) {
    setState(() {
      _page = pageNo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          //appBar itself doens't have a property for linear gradient, so to use linear gradient
          //we can pass flexibleSpace which can be a Container and then container has lienar gradient property
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: EdgeInsets.only(bottom: 8),
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/splash_screen/sabthok.png',
                width: 100,
                height: 40,
                //  color: Colors.white,
              ),
            ),
            const Text(
              'Admin',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )
          ]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: updatePage,
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        items: [
          //posts
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomNavBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.home_outlined),
            ),
            label: '',
          ),
          //anaylitcs
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomNavBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.analytics_outlined),
            ),
            label: '',
          ),
          //indbox
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomNavBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.all_inbox_outlined),
            ),
            label: '',
          ),
        ],
      ),
      body: pages[_page],
    );
  }
}
