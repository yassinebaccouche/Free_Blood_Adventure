import 'package:flutter/material.dart';

Widget customButton(String btnTxt,void Function()? onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      backgroundColor: const Color(0xffE2037A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ), // Background color
    ),
    child: Text(
      btnTxt,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );
}
