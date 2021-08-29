import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:whiteboard_organizer_flutter/dao/materiaDAO.dart';
import 'package:whiteboard_organizer_flutter/dao/quadroDAO.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro.dart';
import 'package:whiteboard_organizer_flutter/screens/materia_config_screen.dart';
import 'package:whiteboard_organizer_flutter/screens/materia_screen.dart';
import 'package:whiteboard_organizer_flutter/screens/quadro_sceen.dart';
import 'package:whiteboard_organizer_flutter/widgets/materia_card.dart';
import 'package:whiteboard_organizer_flutter/widgets/quadro_card.dart';
import 'package:whiteboard_organizer_flutter/widgets/quadro_home_card.dart';
class HomeTab extends StatefulWidget {

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  MateriaDAO materiaDAO = MateriaDAO();
  QuadroDAO quadroDAO = QuadroDAO();
  List<Quadro> quadros = List();
  List<Quadro> quadrosNaoCopiados = List();
  List<Materia> materias = List();

  void initState() {
    super.initState();
    updateList();
  }

  void updateList() {
    // Busca todos as entidades e muda o estado
    materiaDAO.buscaTodasMaterias().then((list) {
      setState(() => materias = list);
    });
     quadroDAO.buscaUltimosQuadros(10).then((list) {
      setState(() => quadros = list);
    });
      quadroDAO.buscaQuadrosNaoCopiados(25).then((list) {
      setState(() => quadrosNaoCopiados = list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text("Pagina Inicial"),
            centerTitle: true,
            actions: [
              IconButton(icon: Icon(Icons.replay_outlined), onPressed: (){
                updateList();
              })
            ],
      ),
      body: ListView(
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
              Padding(
                padding: EdgeInsets.only(top: 15),
              ),
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 273.0,
                  viewportFraction: 0.6,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                itemCount: quadros.length,
                itemBuilder: (context, index, key) {
                  return QuadroHomeCard(this.quadros, index, null, _showQuadroPage);
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
                "Não copiados",
                style: TextStyle(fontSize: 30),
              ),
                            Padding(
                padding: EdgeInsets.only(top: 15),
              ),
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 273.0,
                  viewportFraction: 0.6,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                itemCount: quadrosNaoCopiados.length,
                itemBuilder: (context, index, key) {
                  return QuadroHomeCard(this.quadrosNaoCopiados, index, null, _showQuadroPage);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
  
  void _showQuadroPage({Quadro quadro}) async {
    Quadro quadroRet = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => QuadroScreen(quadro)));
      updateList();
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
