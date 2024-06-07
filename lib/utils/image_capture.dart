import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

Future<ui.Image?> captureImage(GlobalKey key) async {
  try {
    final RenderRepaintBoundary boundary =
    key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    return image;
  } catch (e) {
    print('Error capturing image: $e');
    return null;
  }
}
