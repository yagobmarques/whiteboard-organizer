import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro.dart';

class QuadroHomeCard extends StatelessWidget {
  final List<Quadro> quadros;
  final int index;
  final Function({Quadro quadro}) onLongPress;
  final Function({Quadro quadro}) onTap;

  QuadroHomeCard(this.quadros, this.index, this.onLongPress, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            this.onTap(quadro: this.quadros[index]);
          },
          onLongPress: () {
            this.onLongPress(quadro: this.quadros[index]);
          },
          child: Ink(
              width: 200,
              decoration: BoxDecoration(color: Colors.white),
              child: Stack(alignment: Alignment.center, children: [
                Image.file(
                  File(this.quadros[index].img),
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ]
                  // 'texto ${this.materias[index].name}',
                  // style: TextStyle(fontSize: 16.0),
                  )),
        ),
        Text( this.quadros[index].data != null ? "${this.quadros[index].data.day}/${this.quadros[index].data.month}/${this.quadros[index].data.year}" : "Sem data",
            style: TextStyle(fontSize: 14, color: Colors.black))
      ],
    );
  }
}
