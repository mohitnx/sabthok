import 'package:flutter/material.dart';
import 'package:sabthok/constants/global_variables.dart';
import 'package:sabthok/features/account/widgets/orders.dart';

import '../widgets/below_app_bar.dart';
import '../widgets/top_button.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(10),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: Column(
        children: const [
          BelowAppBar(),
          SizedBox(height: 5),
          TopButtons(),
          SizedBox(height: 10),
          Orders(),
        ],
      ),
    );
  }
}
