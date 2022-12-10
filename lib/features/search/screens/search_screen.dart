import 'package:flutter/material.dart';
import 'package:sabthok/features/search/services/search_services.dart';

import '../../../common/widgets/custom_loader.dart';
import '../../../model/product.dart';
import '../../home/widgets/address_box.dart';
import '../../product_details/screens/product_details_screen.dart';
import '../widget/search_product.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';
  final String searchQuery;
  const SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  SearchServices searchServices = SearchServices();
  List<Product>? products;
  @override
  void initState() {
    super.initState();
    fetchSearchedProducts();
  }

  fetchSearchedProducts() async {
    products = await searchServices.fetchSearchedProducts(
      context: context,
      searchQuery: widget.searchQuery,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          //appBar itself doens't have a property for linear gradient, so to use linear gradient
          //we can pass flexibleSpace which can be a Container and then container has lienar gradient property
          flexibleSpace: Container(
            decoration: const BoxDecoration(),
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 15),
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
                      hintText: 'Search SabtThok',
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
      body: products == null
          ? const Loader()
          : Column(
              children: [
                const AddressBox(),
                const SizedBox(
                  height: 10,
                ),
                //listView builder needs a hieght, so by wrapping in expaneded, it means that lisit view builder can take
                //all the avaible hieght
                Expanded(
                    child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: products!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ProductDetailScreen.routeName,
                                    arguments: products![index]);
                              },
                              child:
                                  SearchedProduct(product: products![index]));
                        }))
              ],
            ),
    );
  }
}
