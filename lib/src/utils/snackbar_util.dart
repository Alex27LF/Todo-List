import 'package:flutter/material.dart';

SnackBar snackBarUtil(String messaje, Color color, Icon icon) {
  return SnackBar(
    elevation: 8,
    dismissDirection: DismissDirection.endToStart,
    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
    behavior: SnackBarBehavior.floating,
    backgroundColor: color,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 5),
        icon,
        const SizedBox(width: 15),
        Text(
          messaje,
          style: const TextStyle(
              fontSize: 22,
              fontFamily: 'Yanone',
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
              color: Colors.black),
        ),
      ],
    ),
    duration: const Duration(seconds: 2),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18),
        bottomRight: Radius.circular(18),
      ),
    ),
  );
}
