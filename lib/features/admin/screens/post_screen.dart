import 'package:flutter/material.dart';
import 'package:sabthok/constants/global_variables.dart';
import 'package:sabthok/features/admin/screens/add_product_screen.dart';

import '../../../common/widgets/custom_loader.dart';
import '../../../model/product.dart';
import '../../account/widgets/single_product.dart';
import '../services/admin_service.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
//why we created a nullable list and not an empty list check in scaffold below
  List<Product>? products;
  final AdminServices adminServies = AdminServices();
  //initState can't be async, so we cant initlailze async func in it, it will give error in runttime
  //so to overcome that, we make an intermediatey func like fetchAllProducts, inside which we can run the
  //fetchAllProducts from admin_service.dart

  //or we can use streambuilder/future builder

  @override
  void initState() {
    super.initState();
    fetchAllProductsIntermediatery();
  }

//to add, show the updated grid after we enere sell without having to go back to differenct screen and come back
  fetchAllProductsIntermediatery() async {
    products = await adminServies.fetchAllProducts(context);
    //after products gets populated with data from fetchAllProducts, we restart the applciaton
    setState(() {});
  }

//calling a function inside a function
  void deleteProduct(Product product, int index) {
    adminServies.deleteProduct(
        context: context,
        product: product,
        onSuuccess: () {
          products!.removeAt(index);
          setState(() {});
        });
  }

  void navigateToAddProduct() {
    //we could do this inside the onPressed, but not mixing ui with business logic
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    //initally produts list is empty
    //if prodects == empty then
    //if the admin hasn't posted anything then  after fetching , products list will still be empty, as we have defined lsit of products =[](empty) in admin servies
    //which means if there are no prducts, and we check using products == empty, then loading indicator will appaer foreever

    //for null

    //initally products list is null
    //if products == null
    //now if the admin hasn't posted anything then after fetching the products list will be empty (empty not equal to null), so Loader wont display, instead scaffold will
    return products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
              itemCount: products!.length,
              //slivderGriddeleigateWtih.....defines how many items in row. here 2
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final productData = products![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 130,
                      //we know images is a list, so we access only the first image to display it
                      child: SingleProduct(src: productData.images[0]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            productData.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteProduct(productData, index);
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: GlobalVariables.primaryColor,
              onPressed: navigateToAddProduct,
              tooltip: 'Add product now',
              child: const Icon(
                Icons.add,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
