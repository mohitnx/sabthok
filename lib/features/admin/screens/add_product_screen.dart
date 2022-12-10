import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:sabthok/common/widgets/custom_button.dart';
import 'package:sabthok/common/widgets/custom_text_filed.dart';
import 'package:sabthok/constants/global_variables.dart';
import 'package:sabthok/constants/utils.dart';

import '../services/admin_service.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/addProduct';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  //to store images
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final AdminServices adminServices = AdminServices();

  void sellProduct() {
    //validate validates the forms but not the images lsit, so we check if it is not empty manually
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      adminServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
        category: categoryDefault,
        images: images,
      );
    }
  }

  List<String> productCategories = [
    'Vegetables',
    'Fruits',
    'Fast Foods',
    'Recipe',
    'Snacks'
  ];

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      //res will hvae a list of images picked by user
      //here we simply assing that list to another list, so that we can use it here, we could use provider for these sort of things
      images = res;
    });
  }

  String categoryDefault = 'Vegetables';
  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
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
            decoration: const BoxDecoration(),
          ),
          title: const Text(
            'Add Product',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _addProductFormKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
              child: Column(
                children: [
                  //if images already has images, we display them otherwise we show a dotted border and ask to selcet imges
                  images.isNotEmpty
                      ? CarouselSlider(
                          items: images.map((File i) {
                            //File= a refrence to a file on the file system
                            //Imgae.netwrok takes String(url), Image.File takes a file from device storege, Imgage.asset takes image from our assets folder inapp
                            return Image.file(
                              i,
                              fit: BoxFit.cover,
                              height: 200,
                            );
                          }).toList(),
                          options: CarouselOptions(
                            //all images will follow this height and veiwportFraction
                            //viewportFraction is betnw 0-1, 1 means whole viewport/screen
                            viewportFraction: 1,
                            height: 200,
                          ),
                        )
                      : GestureDetector(
                          //since it is void we cant use selcetImges(), we have to use selectImages
                          onTap: selectImages,
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.folder_open,
                                    size: 40,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Select Product Images',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                      controller: productNameController,
                      hintText: 'Product Name'),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      controller: descriptionController,
                      hintText: 'Description',
                      maxLines: 7),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: priceController,
                    hintText: 'Price',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: quantityController,
                    hintText: 'Quantity',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                        //items requires a list of DropDownMenuItems, so we can map our productCategory list to return  DropDownMenuttem with child text as items in that productCategory list
                        items: productCategories.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        value: categoryDefault,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        //onChanged specifies what happens when one item is picked frm the dropdonw
                        //so we take teh value that was selected (newVal), and inside setState assign that value to categoryDefault, which is the 'value'so when rebuld occurse, we can see our selected item on the dropdownbutton
                        onChanged: (String? newVal) {
                          setState(() {
                            categoryDefault = newVal!;
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomPrimaryButton(
                    text: 'Sell',
                    onTap: sellProduct,
                    color: GlobalVariables.primaryColor,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
