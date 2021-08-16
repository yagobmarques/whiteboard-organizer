import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';

class MateriaCard extends StatelessWidget {
  final List<Materia> materias;
  final int index;
  final Function({Materia materia}) onLongPress;
  final Function({Materia materia}) onTap;

  MateriaCard(this.materias, this.index, this.onLongPress, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        this.onTap(materia: this.materias[index]);
      },
      onLongPress: () {
        this.onLongPress(materia: this.materias[index]);
      },
      child: Ink(
          width: 200,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(alignment: Alignment.center, children: [
            Image.file(
              File(this.materias[index].img),
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            Text(this.materias[index].name,
                style: TextStyle(fontSize: 30, color: Colors.white))
          ]
              // 'texto ${this.materias[index].name}',
              // style: TextStyle(fontSize: 16.0),
              )),
    );
  }
}
