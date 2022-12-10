import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    var pickedfiles = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    //if picked file is not null and is not empty
    //why we need to check both??
    //ans: null and empty are not the same and
    //ans: the way this plubin is defned, we have to check if it is null first, as it can be null(tryp removeing not null part, we get an error)
    //we have to check it is not empty because empty and null are not same, and teh list(as allowmultipe true), of files returned may be empty
    if (pickedfiles != null && pickedfiles.files.isNotEmpty) {
      //if allowmulitpe was false, we would only have one image, so no need for a loop directly File image = pickedimage
      for (int i = 0; i < pickedfiles.files.length; i++) {
        //adding picked images to teh list of images
        images.add(File(pickedfiles.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}
