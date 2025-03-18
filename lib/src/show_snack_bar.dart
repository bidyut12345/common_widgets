import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text) {
  // debugPrint(MediaQuery.of(context).size.width.toString());
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // width: 500,

      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(255, 75, 75, 75),
      // backgroundColor: Colors.transparent,
      duration: const Duration(milliseconds: 1000),
      padding: EdgeInsets.zero,
      // width: 200,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textScaleFactor: 2,
          style: const TextStyle(color: Color.fromARGB(255, 170, 170, 170)),
          textAlign: TextAlign.center,
        ),
      ),
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 100,
      //   vertical: 100,
      // ),
      margin: EdgeInsets.symmetric(
        horizontal: (MediaQuery.of(context).size.width - 400) / 2,
        vertical: (MediaQuery.of(context).size.height - 90) / 2,
      ),
    ),
  );
}
