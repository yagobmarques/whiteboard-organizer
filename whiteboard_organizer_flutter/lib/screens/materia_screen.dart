import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:whiteboard_organizer_flutter/dao/quadroDAO.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro.dart';
import 'package:whiteboard_organizer_flutter/screens/quadro_config_screen.dart';
import 'package:whiteboard_organizer_flutter/screens/quadro_sceen.dart';
import 'package:whiteboard_organizer_flutter/widgets/quadro_card.dart';

class MateriaScreen extends StatefulWidget {
  Materia materia;
  MateriaScreen(this.materia);

  @override
  _MateriaScreenState createState() => _MateriaScreenState();
}

class _MateriaScreenState extends State<MateriaScreen> {
  QuadroDAO quadroDAO = QuadroDAO();
  List<Quadro> quadros = List();

  void initState() {
    super.initState();
    updateList();
  }

  void updateList() {
    // Busca todos os contatos e muda o estado
    quadroDAO.buscaQuadrosPelaDisciplina(widget.materia.id).then((list) {
      setState(() => quadros = list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.materia.name),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           _showQuadroConfigPage(widget.materia);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            new TextField(
              decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.search),
                labelText: "Pequise um quadro",
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: quadros.length + 1,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                if (quadros.length == 0) {
                  return Center(
                    child: Text("Sem quadros cadastrados"),
                  );
                } else if (index != quadros.length){
                  return QuadroCard(quadros, index, _showQuadroConfigPage, _showQuadroPage, widget.materia);
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQuadroConfigPage( Materia materia, {Quadro quadro}) async {
    Quadro quadroRet = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => QuadroConfigScreen(quadro, materia: materia)));
    if (quadroRet != null) {
      print(quadroRet.id);
      if (quadroRet.id == null)
        await quadroDAO.inserirQuadro(quadroRet);
      else
        await quadroDAO.alterarQuadro(quadroRet);
    }
      updateList();
  }
    void _showQuadroPage({Quadro quadro}) async {
    Quadro quadroRet = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => QuadroScreen(quadro)));
      updateList();
    }
}
