import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:whiteboard_organizer_flutter/dao/quadroDAO.dart';
import 'package:whiteboard_organizer_flutter/dao/quadro_imagemDAO.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro.dart';
import 'package:photo_view/photo_view.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro_imagem.dart';
import 'package:whiteboard_organizer_flutter/screens/ver_quadro_screen.dart';
import 'package:whiteboard_organizer_flutter/widgets/quadro_card_s_tap.dart';
import 'package:whiteboard_organizer_flutter/widgets/quadro_foto_card.dart';

class QuadroScreen extends StatefulWidget {
  Quadro quadro;
  QuadroScreen(this.quadro);

  @override
  _QuadroScreenState createState() => _QuadroScreenState();
}

class _QuadroScreenState extends State<QuadroScreen> {
  QuadroDAO quadroDAO = QuadroDAO();
  PhotoViewScaleStateController scaleStateController;
  List<QuadroImagem> fotos = List<QuadroImagem>();

  Future<void> initState() {
    carregaImages(widget.quadro.id);
    if (fotos == null) {
      fotos = List();
    }
  }

  void carregaImages(int id) async {
    QuadroImagemDAO quadroImagemDAO = QuadroImagemDAO();
    fotos = await quadroImagemDAO.buscaImagensPeloQuadro(id);
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.quadro.name), centerTitle: true, actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              if (this.widget.quadro.id != null) {
                quadroDAO.removerQuadro(widget.quadro.id);
              }
              Navigator.of(context).pop();
            })
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (widget.quadro.copiado == 1) {
            widget.quadro.copiado = 0;
          } else {
            widget.quadro.copiado = 1;
          }
          quadroDAO.alterarQuadro(widget.quadro);
          setState(() {});
        },
        label: Text(widget.quadro.copiado == 1
            ? "Não passar a limpo"
            : "Passar a limpo"),
        backgroundColor: Colors.purpleAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CarouselSlider.builder(
              options: CarouselOptions(
                height: 270.0,
                viewportFraction: 0.5,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
              itemCount: fotos != null ? fotos.length : 0,
              itemBuilder: (context, index, key) {
                // return QuadroFotoCard(fotos[index].img, _verImagem(fotos[index].img), index);
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VerQuadroScreen(fotos[index].img)));
                  },
                  child:
                      Ink(child: QuadroFotoCardSTap(fotos[index].img, index)),
                );

                // return GestureDetector(
                //     onDoubleTap: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => VerQuadroScreen(fotos[index].img)));
                //     },
                //     child: QuadroFotoCard(fotos[index].img, null, index));
              },
            ),
            // Container(
            //   width: 500,
            //   height: 500,
            //   child: PhotoView(
            //     imageProvider: FileImage(File(widget.quadro.img)),
            //     scaleStateController: scaleStateController,
            //     enableRotation: true,
            //     backgroundDecoration: BoxDecoration(color: Colors.transparent),
            //   ),
            // ),
            Padding(padding: EdgeInsets.all(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Anotações:",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.quadro.anotacao,
                    style: TextStyle(fontSize: 25),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _verImagem(String img) {}
}
