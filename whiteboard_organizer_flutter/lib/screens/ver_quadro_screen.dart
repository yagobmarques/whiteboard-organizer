import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class VerQuadroScreen extends StatelessWidget {
  String img;
  VerQuadroScreen(this.img);

  @override
  Widget build(BuildContext context) {
    PhotoViewScaleStateController scaleStateController;
    return Container(
              width: 500,
              height: 500,
              child: PhotoView(
                imageProvider: FileImage(File(this.img)),
                scaleStateController: scaleStateController,
                enableRotation: true,
                backgroundDecoration: BoxDecoration(color: Colors.transparent),
              ),
            );
  }
}