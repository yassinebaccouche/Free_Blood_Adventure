import 'package:flutter/material.dart';

Widget customTextContainer(double width,  String title, String value, Color? specialColor) {
  return Material(
    borderRadius: BorderRadius.circular(10),
    elevation: 5,
    child: Container(
      width: width,
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: specialColor ?? Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
                color: specialColor ?? Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}
