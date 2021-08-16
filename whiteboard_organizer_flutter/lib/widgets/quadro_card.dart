import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro.dart';

class QuadroCard extends StatelessWidget {
  final List<Quadro> quadros;
  final int index;
  final Materia materia;
  final Function(Materia materia, {Quadro quadro}) onLongPress;
  final Function({Quadro quadro}) onTap;

  QuadroCard(this.quadros, this.index, this.onLongPress, this.onTap, this.materia);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: InkWell(
        onTap: () {
          // Navigator.of(context).push(
          // MaterialPageRoute(builder: (context)=>SupplierScreen(snapshot))
        },
        onLongPress: (){
          onLongPress(materia, quadro: quadros[index]);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.file(
              File(this.quadros[index].img),
              width: 50,
              height: 50,
              fit: BoxFit.fill,
            ),
            Padding(padding: EdgeInsets.all(15)),
              Text(quadros[index].name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Padding(padding: EdgeInsets.all(13)),
              Icon(quadros[index].copiado == 1 ? Icons.check: Icons.cancel)
            ],
          ),
        ),
      ),
    );
  }
}