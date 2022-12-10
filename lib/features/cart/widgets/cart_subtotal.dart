import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/user_provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //context.watch is short form of Provider.of<UserProvider>(context)....
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    //provider use garya bhayera...aafai update huncha realtime ma...without setState
    user.cart
        //sum = total objs, * price of one obj, we are doint that here by .map, as we can go to each item in user.cart
        //see Product.dart ko fromMap function, cart is a list of :
        //cart is a list of : Map<String, dynamic>.from(x))) so each elemtn is a map,
        //.map func le we get each element then find sum = sum + each_elemnet['quantity'] multiply each_element['product][price]
        //each_element['product][price] means product bhitra ko price property ..see .js model if confuesd, but very easy
        //and do that for all emelemts until we get finla total...simple
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            'Subtotal ',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            '\$$sum',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
