import 'package:flutter/material.dart';
import 'package:sabthok/constants/global_variables.dart';
import 'package:sabthok/features/home/services/home_service.dart';
import 'package:sabthok/features/product_details/screens/product_details_screen.dart';
import 'package:sabthok/model/product.dart';

import '../../../common/widgets/custom_loader.dart';

class DealOfTheDay extends StatefulWidget {
  const DealOfTheDay({super.key});

  @override
  State<DealOfTheDay> createState() => _DealOfTheDayState();
}

class _DealOfTheDayState extends State<DealOfTheDay> {
  Product? product;
  @override
  //can't have async await in insitState due to runtime error so this way
  //or use futureBuilder instead
  void initState() {
    super.initState();
    fetchDealofTheDay();
    setState(() {});
  }

  fetchDealofTheDay() async {
    product = await HomeServices().fetchDealofTheDay(context: context);
    //while waiting in await, product will be null, since it is nullable, so Loader is seen
    //after fetching also it will show Loader as product will be updated, butto see it we needto refresh screen
    //so setState used, whenver await completes, we rebuild the screen, then product will not be null, and appropriate thigsn can be showbn
    setState(() {});
  }

  void navigateToDetailScreen() {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const Loader()
        //if fecthing complte, but the product has no name(' '), meaning there are no deals of teh day(see fetchDeafoTheDay func for logic)
        //then show sizedBox,
        //else product is not null and there are products then show gesturedetector(column), etc
        : product!.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
                onTap: navigateToDetailScreen,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: const Text(
                        'Deal of the day',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Image.network(
                      product!.images[0],
                      height: 235,
                      fit: BoxFit.fitHeight,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          const EdgeInsets.only(left: 15, top: 5, right: 40),
                      child: const Text(
                        'More images',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: product!.images
                            .map(
                              (e) => Image.network(
                                e,
                                fit: BoxFit.fitWidth,
                                width: 100,
                                height: 100,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ).copyWith(left: 15),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'See all deals',
                        style: TextStyle(
                          color: Colors.cyan[800],
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}
