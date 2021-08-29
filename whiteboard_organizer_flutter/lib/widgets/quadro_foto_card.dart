import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro.dart';

class QuadroFotoCard extends StatelessWidget {
  final String src;
  final int index;
  final Function({int index}) onTap;

  QuadroFotoCard(this.src, this.onTap, this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (this.onTap != null) {
              this.onTap(index: index);  
            }
            
          },
          child: Ink(
              width: 200,
              decoration: BoxDecoration(color: Colors.white),
              child: Stack(alignment: Alignment.center, children: [
                Image.file(
                  File(this.src),
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ]
                  // 'texto ${this.materias[index].name}',
                  // style: TextStyle(fontSize: 16.0),
                  )),
        ),
      ],
    );
  }
}
