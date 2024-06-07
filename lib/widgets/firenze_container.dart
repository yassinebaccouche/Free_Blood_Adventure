import 'package:flutter/material.dart';

class ContainerFirenze extends StatelessWidget {
  final double height;
  final double width;
  const ContainerFirenze({super.key,required this.height,required this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Station4.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
