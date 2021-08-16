import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:whiteboard_organizer_flutter/dao/quadroDAO.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro.dart';

class QuadroConfigScreen extends StatefulWidget {
  Quadro quadro;
  Materia materia;
  QuadroConfigScreen(this.quadro, {this.materia});

  @override
  _QuadroScreenState createState() => _QuadroScreenState();
}

class _QuadroScreenState extends State<QuadroConfigScreen> {
  Quadro _quadroEditado;
  bool _usuarioEditou;
  final _nomeFocus = FocusNode();
  DateTime selectedDate = DateTime.now();
  int copiado = 1;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nomeController = TextEditingController();
  TextEditingController anotacaoController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController aulaController = TextEditingController();
  TextEditingController copiadoController = TextEditingController();
  TextEditingController materiaController = TextEditingController();

  void initState() {
    super.initState();
    if (widget.quadro == null) {
      // Se n estiver criado, crie um
      _quadroEditado = Quadro();
    } else {
      _quadroEditado = Quadro.fromMap(widget.quadro.toMap());
      nomeController.text = _quadroEditado.name;
      anotacaoController.text = _quadroEditado.anotacao;
      //selectedDate = _quadroEditado.data;
      copiado = _quadroEditado.copiado;
    }
    materiaController.text = widget.materia.name;
  }

  Future<void> _selectDate(BuildContext context) async {
    _usuarioEditou = true;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2101));
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
          title: Text(_quadroEditado.name ?? "Novo quadro"),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.delete), onPressed: (){
              QuadroDAO quadroDAO = QuadroDAO();
              if(this._quadroEditado.id != null){
                quadroDAO.removerQuadro(_quadroEditado.id);
              }
              Navigator.of(context).pop();
            })
          ],
        ),
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
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
              Navigator.pop(context, _quadroEditado);
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
              GestureDetector(
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _quadroEditado.img != null
                              ? FileImage(File(_quadroEditado.img))
                              : AssetImage("Images/user.png"))),
                ),
                onTap: () {
                  _escolherImagem();
                },
              ),
              TextField(
                controller: nomeController,
                focusNode: _nomeFocus,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _usuarioEditou = true;
                  setState(() {
                    _quadroEditado.name = text;
                  });
                },
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              TextField(
                controller: anotacaoController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(labelText: "Anotação (Opcional)"),
                onChanged: (text) {
                  _usuarioEditou = true;
                  setState(() {
                    _quadroEditado.anotacao = text;
                  });
                },
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              TextField(
                controller: materiaController,
                enabled: false,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(labelText: "Matéria"),
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
                    "Criado em ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    style: TextStyle(fontSize: 20),
                  ),
                  RaisedButton(
                    color: Colors.blueGrey,
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
                      activeColor: Colors.blueGrey,
                      onChanged: (newValue) {
                        setState(() {
                          _usuarioEditou = true;
                          int value = 0;
                          if(newValue == true){
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
                            _quadroEditado.img = file.path;
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
                            _quadroEditado.img = file.path;
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
