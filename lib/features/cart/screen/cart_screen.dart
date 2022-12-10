import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabthok/common/widgets/bottom_nav_bar.dart';
import 'package:sabthok/common/widgets/custom_button.dart';
import 'package:sabthok/common/widgets/show_snackbar.dart';

import '../../../constants/global_variables.dart';
import '../../../provider/user_provider.dart';

import '../../home/widgets/address_box.dart';
import '../../search/screens/search_screen.dart';
import '../widgets/cart_product.dart';
import '../widgets/cart_subtotal.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void buyFunction() {
    Navigator.pushNamed(context, BottomNaviBar.routeName);
    showSnackBar(context, 'Your Order Has Been Placed', 1);
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
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
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 15),
                height: 42,
                //we could have used Container instead of Material, but we need eleavtion ... so
                child: Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(7),
                  child: TextFormField(
                    //due to the natuer of onFieldSubmitted, we don't have to manually pass teh string to navigateToSearchScreen
                    //see teh docu, when the user enters some text, it is automaticlly passed to navigateToSearchScreen
                    //try removing String query from navigateToSearcScrene, then we can't use it in onFiledSubmitetd, as it needs a func that can receive a string
                    onFieldSubmitted: navigateToSearchScreen,
                    decoration: InputDecoration(
                      prefixIcon: InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 23,
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(top: 10),
                      //this boerder is for boerder in focus
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                          //.none means onFous ma also there is no border outline
                        ),
                        borderSide: BorderSide.none,
                      ),
                      //this border is for border out of focs
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                          //above there is borderSide nonne, here there is borderside of width1, so the effect this creates is
                          //before clicking on search bar there is slight border side due to this width1 and black38, but as it comes on fouse
                          //when we click on it, border dissapers and boderside = none in above
                        ),
                        borderSide: BorderSide(color: Colors.black38, width: 1),
                      ),
                      hintText: 'Search Sabthok',
                      hintStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              height: 43,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const Icon(
                Icons.mic,
                color: Colors.black,
                size: 28,
              ),
            )
          ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomPrimaryButton(
                text: 'Proceed to Buy (${user.cart.length} items)',
                onTap: buyFunction,
                color: GlobalVariables.primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              color: Colors.black12.withOpacity(0.08),
              height: 1,
            ),
            const SizedBox(height: 5),
            ListView.builder(
              itemCount: user.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(
                  index: index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
