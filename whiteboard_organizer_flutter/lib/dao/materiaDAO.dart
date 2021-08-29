import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:whiteboard_organizer_flutter/dao/quadroDAO.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro_imagem.dart';

class MateriaDAO {
  // Usando o padrão Singleton
  static final MateriaDAO _instance = MateriaDAO.internal();

  factory MateriaDAO() => _instance;

  MateriaDAO.internal();

  Database _db;

  Future<Database> get db async {
    if (_db == null) {
      // Cria um BD apenas uma vez
      _db = await initDb();
    }
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "whiteboard.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          // Criando a tabela de contato
          "CREATE TABLE ${Materia.materiaTable}(${Materia.idColumn} INTEGER PRIMARY KEY, "
          "                                 ${Materia.nameColumn} TEXT, "
          "                                 ${Materia.imgColumn} TEXT);"
          "CREATE TABLE ${Quadro.quadroTable}(${Quadro.idColumn} INTEGER PRIMARY KEY, "
          "                                 ${Quadro.nameColumn} TEXT, "
          "                                 ${Quadro.disciplinaColumn} INTEGER REFERENCES ${Materia.materiaTable}, "
          "                                 ${Quadro.aulaColumn} INTEGER, "
          "                                 ${Quadro.copiadoColumn} INTEGER, "
          "                                 ${Quadro.dataColumn} DATE, "
          "                                 ${Quadro.anotacaoColumn} TEXT, "
          "                                 ${Quadro.imgColumn} TEXT) ;");
      await db.execute(
          // Criando a tabela de contato
          "CREATE TABLE ${QuadroImagem.quadroImagemTable}(${QuadroImagem.idColumn} INTEGER PRIMARY KEY, "
          "                                 ${QuadroImagem.idQuadroColumn} INTEGER REFERENCES ${Quadro.quadroTable}, "
          "                                 ${QuadroImagem.imgColumn});");
    });
  }

  Future<Materia> inserirMateria(Materia m) async {
    Database dbContact = await db;
    // insert é uma função pronta do SQLite
    m.id = await dbContact.insert(Materia.materiaTable, m.toMap());
    return m;
  }

  Future<Materia> buscaMateriaPeloId(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(Materia.materiaTable,
        columns: [Materia.idColumn, Materia.nameColumn, Materia.imgColumn],
        where: "${Materia.idColumn} = ?",
        whereArgs: [id]); // Filtrando a busca pelo ID

    if (maps.length > 0)
      return Materia.fromMap(
          maps.first); //Usadoo first, mas o BD deve reornar apenas 1
    else
      return null;
  }

  Future<int> removerMateria(int id) async {
    QuadroDAO quadroDAO = QuadroDAO();
    Database dbContact = await db;
    // await dbContact.delete(Quadro.quadroTable,
    // where: "${Quadro.disciplinaColumn} = ?", whereArgs: [id]);
    List quadros = await quadroDAO.buscaQuadrosPelaDisciplina(id);
    for (Quadro q in quadros) {
      quadroDAO.removerQuadro(q.id);
    }
    return await dbContact.delete(Materia.materiaTable,
        where: "${Materia.idColumn} = ?", whereArgs: [id]); //Filtrando pelo id
  }

  Future<int> alterarMateria(Materia m) async {
    Database dbContact = await db;
    return await dbContact.update(Materia.materiaTable, m.toMap(),
        where: "${Materia.idColumn} = ?", whereArgs: [m.id]);
  }

  Future<List> buscaTodasMaterias() async {
    Database dbContact = await db;
    List listMap =
        await dbContact.query(Materia.materiaTable); //Retorna todas as Tuplas
    List<Materia> listContacts = List();
    for (Map m in listMap) {
      listContacts.add(Materia.fromMap(m));
    }
    return listContacts;
  }

  Future<int> pegaTamanho() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery(
        "select count(*) from ${Materia.materiaTable}")); //Retorna a quantidade de tuplas
  }
}
