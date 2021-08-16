import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';

class MateriaConfigScreen extends StatefulWidget {
  Materia materia;
  MateriaConfigScreen(this.materia);

  @override
  _MateriaScreenState createState() => _MateriaScreenState();
}

class _MateriaScreenState extends State<MateriaConfigScreen> {
  Materia _materiaEditada;
  bool _usuarioEditou;
  final _nomeFocus = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nomeController = TextEditingController();

  void initState() {
    super.initState();
    if (widget.materia == null) {
      // Se n estiver criado, crie um
      _materiaEditada = Materia();
    } else {
      _materiaEditada = Materia.fromMap(widget.materia.toMap());
      nomeController.text = _materiaEditada.name;
    }
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
                    child: Text("cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                FlatButton(
                  child: Text("sim"),
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
          title: Text(_materiaEditada.name ?? "Nova matéria"),
          centerTitle: true,
        ),
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_materiaEditada.img == null || _materiaEditada.img.isEmpty) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  "Adicione uma imagem",
                  style: TextStyle(fontSize: 15),
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ));
            } else if (_materiaEditada.name != null &&
                _materiaEditada.name.isNotEmpty) {
              Navigator.pop(context, _materiaEditada);
            } else {
              FocusScope.of(context).requestFocus(_nomeFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                controller: nomeController,
                focusNode: _nomeFocus,
                style: TextStyle(
                  fontSize:30
                ),
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _usuarioEditou = true;
                  setState(() {
                    _materiaEditada.name = text;
                  });
                },
              ),
              Padding(padding: EdgeInsets.only(bottom: 40)),
              GestureDetector(
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _materiaEditada.img != null
                              ? FileImage(File(_materiaEditada.img))
                              : AssetImage("Images/user.png"))),
                ),
                onTap: () {
                  _escolherImagem();
                  // ImagePicker()
                  //     .getImage(source: ImageSource.camera)
                  //     .then((file) {
                  //   if (file == null) {
                  //     return;
                  //   } else {
                  //     setState(() {
                  //       _contatoEditado.img = file.path;
                  //     });
                  //   }
                  // });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _escolherImagem() {
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
                            _materiaEditada.img = file.path;
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
                            _materiaEditada.img = file.path;
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
