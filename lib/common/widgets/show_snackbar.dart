import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sabthok/constants/global_variables.dart';

void showSnackBar(BuildContext context, String text, int i) {
  //same int i used to determine snackbar title and color
  List<String> snackbarTitle = ['Oh snap!', 'Success!'];
  List<Color> snackbarImageColor = [
    Color.fromARGB(237, 150, 8, 29),
    Color.fromARGB(238, 19, 151, 101)
  ];
  List<Color> snackbarColor = [
    Color.fromARGB(255, 200, 55, 77),
    Color.fromARGB(255, 23, 117, 81)
  ];
  List<String> snackbarImage = [
    'assets/images/snackbar_image.png',
    'assets/images/snackbar_image_3.png'
  ];
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          //more customization, maybe later?
          //add custom clipping path to make snackbarbox with a wave of diff color
          //or/and make the snackbar box gradient
          Container(
            padding: EdgeInsets.only(left: 22, top: 16, bottom: 18, right: 18),
            decoration: BoxDecoration(
              color: snackbarColor[i],
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            height: 80,

            //width is always constant, specifilly chaning it also deosn't work
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                ),
                //now children of column fill the enter availbae spaces to them
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snackbarTitle[i],
                        style: TextStyle(
                          color:
                              GlobalVariables.backgroundColor.withOpacity(0.5),
                          fontSize: 21,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          color:
                              GlobalVariables.backgroundColor.withOpacity(0.4),
                          fontSize: 11,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 22,
            left: -5,
            child: Container(
              width: 80,
              height: 90,
              child: Image.asset(
                snackbarImage[i],
                color: snackbarImageColor[i],
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            right: -8,
            child: Container(
                width: 60,
                height: 77,
                child: Image.asset(
                  'assets/images/snackbar_image_2.png',
                  color: snackbarImageColor[i],
                )),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      //turns out this also has a color, so to see th contiaer color dsipaled without a outer bordr,
      //keep the background color transparent
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}










//barebone snackbar
/**
 * void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      
    ),
  );
}
 */
