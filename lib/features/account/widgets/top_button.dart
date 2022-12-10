import 'package:flutter/material.dart';
import 'package:sabthok/features/account/widgets/account_button.dart';

import '../services/account_services.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: 'Your Orders',
              onTap: () {},
            ),
            AccountButton(
              text: 'Change Account Type',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
              text: 'Log Out',
              onTap: () => logOut(context),
            ),
            AccountButton(
              text: 'Wish List',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
