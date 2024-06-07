import 'package:flutter/material.dart';

class ContainerPisa extends StatelessWidget {
  final double height;
  final double width;
  const ContainerPisa({super.key,required this.height,required this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Station6.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
