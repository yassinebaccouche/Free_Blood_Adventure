import 'package:flutter/material.dart';

class ContainerNapoli extends StatelessWidget {
  final double height;
  final double width;
  const ContainerNapoli({super.key,required this.height,required this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/napoli.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
