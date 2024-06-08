import 'package:flutter/material.dart';

class BottomModal {
  static void showCustomDialog(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          width: screenWidth,
          child: const Text("test"),
        );
      },
    );
  }
}
