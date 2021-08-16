import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:whiteboard_organizer_flutter/dao/materiaDAO.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';
import 'package:whiteboard_organizer_flutter/screens/materia_config_screen.dart';
import 'package:whiteboard_organizer_flutter/screens/materia_screen.dart';
import 'package:whiteboard_organizer_flutter/widgets/materia_card.dart';

class HomeTab extends StatefulWidget {
  PageController controller;
  HomeTab(this.controller);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  MateriaDAO materiaDAO = MateriaDAO();
  List<Materia> materias = List();

  void initState() {
    super.initState();
    updateList();
  }

  void updateList() {
    // Busca todos os contatos e muda o estado
    materiaDAO.buscaTodasMaterias().then((list) {
      setState(() => materias = list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Matérias",
              style: TextStyle(fontSize: 30),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            CarouselSlider.builder(
              options: CarouselOptions(
                height: 200.0,
                viewportFraction: 0.5,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
              itemCount: materias.length + 1,
              itemBuilder: (context, index, key) {
                if (index == materias.length) {
                  return InkWell(
                    onTap: () {
                      _showMateriaPage();
                    },
                    child: Ink(
                        width: 200,
                        decoration: BoxDecoration(color: Colors.grey),
                        child: Stack(
                          alignment: Alignment.center,
                          children : [
                            Icon(Icons.add_rounded, size: 100,)
                          ]                  
                        )),
                  );
                }
                return MateriaCard(this.materias, index, _showMateriaPage, _showMateriaQuadroPage);
              },
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Últimos quadros",
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Não copiados",
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ],
    );
  }

  void _showMateriaPage({Materia materia}) async {
    // Materia materiaRet = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => MateriaScreen()));
    Materia materiaRet = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => MateriaConfigScreen(materia)));
     
    if (materiaRet != null) {
      print(materiaRet.id);
      if (materiaRet.id == null)
        await materiaDAO.inserirMateria(materiaRet);
      else
        await materiaDAO.alterarMateria(materiaRet);

      updateList();
    }
  }
  void _showMateriaQuadroPage({Materia materia}) async {
    // Materia materiaRet = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => MateriaScreen()));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MateriaScreen(materia)));
     
    // if (materiaRet != null) {
    //   print(materiaRet.id);
    //   if (materiaRet.id == null)
    //     await materiaDAO.inserirMateria(materiaRet);
    //   else
    //     await materiaDAO.alterarMateria(materiaRet);
      updateList();
  }
}
