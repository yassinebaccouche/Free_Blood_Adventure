import 'package:flutter/material.dart';

Widget customTransparentContainer(double width,  Widget body, double vPaddingVal) {
  return Center(
    child: Material(
      elevation: 20,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: vPaddingVal),
        decoration: BoxDecoration(
          color: const Color(0xffB3DEEE).withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
        ),
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: body,
          ),
        ),
      ),
    ),
  );
}
