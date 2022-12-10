import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabthok/common/widgets/custom_button.dart';
import 'package:sabthok/constants/global_variables.dart';
import 'package:sabthok/features/account/widgets/single_product.dart';

import '../../../provider/user_provider.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  int currentStep = 2;
  @override
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 15,
                ),
                child: const Text(
                  'Your Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  right: 15,
                ),
                child: Text(
                  'See all',
                  style: TextStyle(
                    color: GlobalVariables.selectedNavBarColor,
                  ),
                ),
              ),
            ],
          ),
          // display orders
          Container(
            height: 133,
            padding: const EdgeInsets.only(
              left: 10,
              right: 0,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: SingleProduct(
                    src:
                        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=699&q=80',
                  ),
                );
              },
            ),
          ),

          Text(
            'Track Your Order',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          //tracking user
          Stepper(
            currentStep: 2,
            controlsBuilder: (context, details) {
              if (user.usertype == 'admin') {
                return CustomPrimaryButton(
                  text: 'Done',
                  color: GlobalVariables.primaryColor,
                  onTap: () {},
                );
              }
              return const SizedBox();
            },
            steps: [
              Step(
                title: const Text('Pending'),
                content: const Text(
                  'Your order is yet to be delivered',
                ),
                isActive: currentStep > 0,
                state: currentStep > 0 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: const Text('Completed'),
                content: const Text(
                  'Your order has been delivered, you are yet to sign.',
                ),
                isActive: currentStep > 1,
                state: currentStep > 1 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: const Text('Received'),
                content: const Text(
                  'Your order has been delivered and signed by you.',
                ),
                isActive: currentStep > 2,
                state: currentStep > 2 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: const Text('Delivered'),
                content: const Text(
                  'Your order has been delivered and signed by you!',
                ),
                isActive: currentStep >= 3,
                state:
                    currentStep >= 3 ? StepState.complete : StepState.indexed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
