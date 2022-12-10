import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sabthok/common/widgets/custom_button.dart';
import 'package:sabthok/features/cart/screen/cart_screen.dart';
import 'package:sabthok/model/product.dart';

import '../../../common/widgets/rating_star.dart';
import '../../../constants/global_variables.dart';
import '../../../provider/user_provider.dart';
import '../../search/screens/search_screen.dart';
import '../services/product_details_services.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailScreen({required this.product, super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  double avgRating = 0;
  double myRating = 0;
  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    for (int i = 0; i < widget.product.rating!.length; i++) {
      //finding sum of all the ratings of a product
      totalRating += widget.product.rating![i].rating;
      //rating of a particular user..so that we can display the changes made..
      //each rating has uiserId of who rated it and the actual rating
      //so if the rating userid matches the userid of the person currently trying to change/add rating
      //then we can say ok, you can change YOUR rating
      //and display the rating chagnes accordingly
      if (widget.product.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }
    //checking if the product has any ratings, if it done'st display 0, if yes, find aveRating to display
    //by total ratings that we looped to find above, by the total no of users who have rated it
    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    } else {
      avgRating = 0;
    }
  }

  void addToCartt() async {
    await productDetailsServices.addToCart(
        context: context, product: widget.product);
  }

  ProductDetailsServices productDetailsServices = ProductDetailsServices();
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
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
                      hintText: 'Search SabThok',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ProductId:   ${widget.product.id!}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Stars(rating: avgRating),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            CarouselSlider(
              items: widget.product.images.map((i) {
                return Image.network(
                  i,
                  //.contain = as lareg as possible while entirely containg teh source in the target box
                  //.cover = .contain ko ulto, smallest as possible while entirely conaintg  the imge in traget box
                  fit: BoxFit.contain,
                  height: 200,
                );
              }).toList(),
              options: CarouselOptions(
                //all images will follow this height and veiwportFraction
                //viewportFraction is betnw 0-1, 1 means whole viewport/screen
                viewportFraction: 1,
                height: 300,
              ),
            ),

            Container(
              height: 5,
              color: Colors.black12,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text: 'Deal Price: ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '\$${widget.product.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.description,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomPrimaryButton(
                text: 'Buy Now',
                color: GlobalVariables.primaryColor,
                onTap: () {
                  print('test');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: ((context) => CartScreen())));
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomSecondaryButton(
                text: '  Add to Cart  ',
                onTap: addToCartt,
                color: const Color.fromRGBO(254, 216, 19, 1),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Rate This Product',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //property of rating pacakge
            RatingBar.builder(
              //inital rating depends on the average rating received so far on thta product
              initialRating: myRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              //padding betn the 5 Icons.star
              itemPadding: const EdgeInsets.symmetric(horizontal: 5),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: GlobalVariables.primaryColor,
              ),
              //whenever rating updates, what do we need to do?
              onRatingUpdate: (rating) {
                productDetailsServices.rateProduct(
                  context: context,
                  product: widget.product,
                  rating: rating,
                );
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}
