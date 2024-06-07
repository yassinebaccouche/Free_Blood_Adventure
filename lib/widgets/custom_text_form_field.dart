import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customTextFormField( TextEditingController? controller, String hint, String imagePath, TextInputType type, TextInputAction action) {
  return Container(
    height: 30,
    padding: EdgeInsets.zero,
    child: TextFormField(
      style: const TextStyle(
        fontSize: 12,
      ),
      controller: controller,
      cursorColor: const Color(0xffE2037A),
      keyboardType: type,
      textInputAction: action,
      decoration: InputDecoration(
        isDense: true, // Added this
        contentPadding: EdgeInsets.zero,
        labelText: hint,
        labelStyle: const TextStyle(
          fontSize: 12,
          color: CupertinoColors.systemGrey2,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: CupertinoColors.systemGrey2,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: CupertinoColors.systemGrey2,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: CupertinoColors.systemGrey2,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            imagePath,
          ),
        ),
      ),
    ),
  );
}
