import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:whiteboard_organizer_flutter/dao/quadroDAO.dart';
import 'package:whiteboard_organizer_flutter/dao/quadro_imagemDAO.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro_imagem.dart';
import 'package:whiteboard_organizer_flutter/widgets/quadro_foto_card.dart';

class QuadroConfigScreen extends StatefulWidget {
  Quadro quadro;
  Materia materia;
  QuadroConfigScreen(this.quadro, {this.materia});

  @override
  _QuadroScreenState createState() => _QuadroScreenState();
}

class _QuadroScreenState extends State<QuadroConfigScreen> {
  QuadroImagemDAO quadroImagemDAO = QuadroImagemDAO();
  Quadro _quadroEditado;
  bool _usuarioEditou;
  final _nomeFocus = FocusNode();
  DateTime selectedDate = DateTime.now();
  int copiado = 1;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<QuadroImagem> fotos = List<QuadroImagem>();

  TextEditingController nomeController = TextEditingController();
  TextEditingController anotacaoController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController aulaController = TextEditingController();
  TextEditingController copiadoController = TextEditingController();
  TextEditingController materiaController = TextEditingController();

  Future<void> initState() {
    super.initState();
    if (widget.quadro == null) {
      // Se n estiver criado, crie um
      _quadroEditado = Quadro();
    } else {
      _quadroEditado = widget.quadro;
      nomeController.text = _quadroEditado.name;
      anotacaoController.text = _quadroEditado.anotacao;
      selectedDate = _quadroEditado.data;
      copiado = _quadroEditado.copiado;
      carregaImages(_quadroEditado.id);
      // quadroImagemDAO
      //     .buscaImagensPeloQuadro(_quadroEditado.id)
      //     .whenComplete((listFotos) => () {
      //       print(listFotos);
      //           fotos = listFotos;
      //         });
      //fotos = await quadroImagemDAO.buscaImagensPeloQuadro(_quadroEditado.id);
      if (fotos == null) {
        fotos = List();
      }
    }
    materiaController.text = widget.materia.name;
  }

  carregaImages(int id) async {
    QuadroImagemDAO quadroImagemDAO = QuadroImagemDAO();
    fotos = await quadroImagemDAO.buscaImagensPeloQuadro(id);
    setState(() {});
    return;
  }

  Future<void> _selectDate(BuildContext context) async {
    _usuarioEditou = true;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate != null ? selectedDate : new DateTime.now(),
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: Colors.purple,
              ),
            ),
            child: child,
          );
        });
    if (picked != null)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<bool> _requestPop() {
    if (_usuarioEditou != null && _usuarioEditou) {
      showDialog(
          context: context,
          builder: (context) {
            // Alerta para caso o usuário saia sem salvar
            return AlertDialog(
              title: Text("Abandonar alteração?"),
              content: Text("Os dados serão perdidos."),
              actions: <Widget>[
                FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    //desempilha 2x
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    } else {
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text(_quadroEditado.name ?? "Novo quadro"),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  QuadroDAO quadroDAO = QuadroDAO();
                  if (this._quadroEditado.id != null) {
                    quadroDAO.removerQuadro(_quadroEditado.id);
                  }
                  Navigator.pop(context);
                })
          ],
        ),
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            QuadroDAO quadroDAO = QuadroDAO();
            QuadroImagemDAO quadroImagemDAO = QuadroImagemDAO();
            _quadroEditado.copiado = this.copiado;
            _quadroEditado.disciplina = widget.materia.id;
            _quadroEditado.data = DateTime.parse(selectedDate.toString());
            if (_quadroEditado.img == null || _quadroEditado.img.isEmpty) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  "Adicione uma imagem",
                  style: TextStyle(fontSize: 15),
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ));
            } else if (_quadroEditado.name != null &&
                _quadroEditado.name.isNotEmpty) {
              if (_quadroEditado.id == null) {
                Quadro resultado =
                    await quadroDAO.inserirQuadro(_quadroEditado);
                _quadroEditado.id = resultado.id;
                for (QuadroImagem qi in fotos) {
                  qi.idQuadro = resultado.id;
                  await quadroImagemDAO.inserirMateriaQuadro(qi);
                }
              } else {
                await quadroDAO.alterarQuadro(_quadroEditado);
                for (QuadroImagem qi in fotos) {
                  if (qi.idQuadro != null) {
                    await quadroImagemDAO.alterarQuadroImagem(qi);
                  } else {
                    qi.idQuadro = _quadroEditado.id;
                    await quadroImagemDAO.inserirMateriaQuadro(qi);
                  }
                }
                Navigator.pop(context, _quadroEditado);
              }
            } else {
              FocusScope.of(context).requestFocus(_nomeFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              // GestureDetector(
              //   child: Container(
              //     width: 400,
              //     height: 400,
              //     decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         image: DecorationImage(
              //             image: _quadroEditado.img != null
              //                 ? FileImage(File(_quadroEditado.img))
              //                 : AssetImage("Images/user.png"))),
              //   ),
              //   onTap: () {
              //     _escolherImagem();
              //   },
              // ),
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 270.0,
                  viewportFraction: 0.5,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                itemCount: fotos != null ? fotos.length + 1 : 1,
                itemBuilder: (context, index, key) {
                  if (index == fotos.length) {
                    return InkWell(
                      onTap: () {
                        _escolherImagem();
                      },
                      child: Ink(
                          width: 200,
                          decoration: BoxDecoration(color: Colors.grey),
                          child: Stack(alignment: Alignment.center, children: [
                            Icon(
                              Icons.add_rounded,
                              size: 100,
                            )
                          ])),
                    );
                  }
                  return QuadroFotoCard(
                      fotos[index].img, _escolherImagem, index);
                },
              ),
              Padding(padding: EdgeInsets.only(bottom: 30)),
              TextField(
                cursorColor: Colors.black,
                controller: nomeController,
                focusNode: _nomeFocus,
                style: TextStyle(fontSize: 20),
                decoration: new InputDecoration(
                  labelText: "Nome do quadro",
                  labelStyle: TextStyle(color: Colors.purple),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                onChanged: (text) {
                  _usuarioEditou = true;
                  setState(() {
                    _quadroEditado.name = text;
                  });
                },
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              TextField(
                cursorColor: Colors.black,
                controller: anotacaoController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: "Anotação (opcional)",
                  labelStyle: TextStyle(color: Colors.purple),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                onChanged: (text) {
                  _usuarioEditou = true;
                  setState(() {
                    _quadroEditado.anotacao = text;
                  });
                },
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              TextField(
                cursorColor: Colors.black,
                controller: materiaController,
                enabled: false,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: "Nome da matéria",
                  labelStyle: TextStyle(color: Colors.purple),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                onChanged: (text) {
                  _usuarioEditou = true;
                  setState(() {
                    _quadroEditado.disciplina = widget.materia.id;
                  });
                },
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    selectedDate != null
                        ? "Criado em ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                        : "Escolha uma data",
                    style: TextStyle(fontSize: 20),
                  ),
                  RaisedButton(
                    color: Colors.purpleAccent,
                    child: Icon(Icons.date_range),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Foi passado a limpo?",
                    style: TextStyle(fontSize: 20),
                  ),
                  Switch(
                      value: copiado == 1,
                      activeColor: Colors.purpleAccent,
                      onChanged: (newValue) {
                        setState(() {
                          _usuarioEditou = true;
                          int value = 1;
                          if (newValue == true) {
                            value = 1;
                          }
                          copiado = value;
                        });
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _escolherImagem({int index}) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            insetPadding: EdgeInsets.all(10),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SimpleDialogOption(
                    child: Text("Câmera", style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      ImagePicker()
                          .getImage(source: ImageSource.camera)
                          .then((file) {
                        if (file == null) {
                          return;
                        } else {
                          setState(() {
                            if (index != null) {
                              fotos[index].img = file.path;
                            } else {
                              QuadroImagem quadroImagem = QuadroImagem();
                              quadroImagem.img = file.path;
                              fotos.add(quadroImagem);
                              _quadroEditado.img = file.path;
                            }
                          });
                        }
                      });
                      _usuarioEditou = true;
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    color: Colors.blue,
                  ),
                  SimpleDialogOption(
                    child: Text("Escolher da Galeria",
                        style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      ImagePicker()
                          .getImage(source: ImageSource.gallery)
                          .then((file) {
                        if (file == null) {
                          return;
                        } else {
                          setState(() {
                            if (index != null) {
                              fotos[index].img = file.path;
                            } else {
                              QuadroImagem quadroImagem = QuadroImagem();
                              quadroImagem.img = file.path;
                              fotos.add(quadroImagem);
                              _quadroEditado.img = file.path;
                            }
                          });
                        }
                      });
                      _usuarioEditou = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}
