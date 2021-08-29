import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro_imagem.dart';

class QuadroDAO {
  // Usando o padrão Singleton
  static final QuadroDAO _instance = QuadroDAO.internal();

  factory QuadroDAO() => _instance;

  QuadroDAO.internal();

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
          "CREATE TABLE ${Quadro.quadroTable}(${Quadro.idColumn} INTEGER PRIMARY KEY, "
          "                                 ${Quadro.nameColumn} TEXT, "
          "                                 ${Quadro.disciplinaColumn} INTEGER REFERENCES ${Materia.materiaTable}, "
          "                                 ${Quadro.aulaColumn} INTEGER, "
          "                                 ${Quadro.copiadoColumn} INTEGER, "
          "                                 ${Quadro.dataColumn} DATE, "
          "                                 ${Quadro.anotacaoColumn} TEXT, "
          "                                 ${Quadro.imgColumn} TEXT) ;");
    });
  }

  Future<Quadro> inserirQuadro(Quadro q) async {
    Database dbContact = await db;
    // insert é uma função pronta do SQLite
    q.id = await dbContact.insert(Quadro.quadroTable, q.toMap());
    return q;
  }

  Future<Quadro> buscaQudroaPeloId(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(Quadro.quadroTable,
        columns: [
          Quadro.idColumn,
          Quadro.nameColumn,
          Quadro.imgColumn,
          Quadro.aulaColumn,
          Quadro.copiadoColumn,
          Quadro.dataColumn,
          Quadro.disciplinaColumn,
          Quadro.anotacaoColumn
        ],
        where: "${Quadro.idColumn} = ?",
        whereArgs: [id]); // Filtrando a busca pelo ID

    if (maps.length > 0)
      return Quadro.fromMap(
          maps.first); //Usadoo first, mas o BD deve reornar apenas 1
    else
      return null;
  }

  Future<int> removerQuadro(int id) async {
    Database dbContact = await db;
    await dbContact.delete(QuadroImagem.quadroImagemTable,
      where: "${QuadroImagem.idQuadroColumn} = ?", whereArgs: [id]); // Deletando todas as imagens desse quadro
    return await dbContact.delete(Quadro.quadroTable,
        where: "${Quadro.idColumn} = ?", whereArgs: [id]); //Filtrando pelo id
  }

  Future<int> alterarQuadro(Quadro q) async {
    Database dbContact = await db;
    return await dbContact.update(Quadro.quadroTable, q.toMap(),
        where: "${Quadro.idColumn} = ?", whereArgs: [q.id]);
  }

  Future<List> buscaTodosQuadros() async {
    Database dbContact = await db;
    // dbContact.execute(
    //       // Criando a tabela de contato
    //       "CREATE TABLE ${Quadro.quadroTable}(${Quadro.idColumn} INTEGER PRIMARY KEY, "
    //       "                                 ${Quadro.nameColumn} TEXT, "
    //       "                                 ${Quadro.disciplinaColumn} INTEGER REFERENCES ${Materia.materiaTable}, "
    //       "                                 ${Quadro.aulaColumn} INTEGER, "
    //       "                                 ${Quadro.copiadoColumn} INTEGER, "
    //       "                                 ${Quadro.dataColumn} DATE, "
    //       "                                 ${Quadro.anotacaoColumn} TEXT, "
    //       "                                 ${Quadro.imgColumn} TEXT) ;");
    List listMap =
        await dbContact.query(Quadro.quadroTable); //Retorna todas as Tuplas
    List<Quadro> listQuadros = List();
    for (Map m in listMap) {
      listQuadros.add(Quadro.fromMap(m));
    }
    return listQuadros;
  }

  Future<List> buscaQuadrosPelaDisciplina(int id) async {
    Database dbContact = await db;
    List<Quadro> listQuadros = List();
    List<Map> maps = await dbContact.query(Quadro.quadroTable,
        columns: [
          Quadro.idColumn,
          Quadro.nameColumn,
          Quadro.imgColumn,
          Quadro.aulaColumn,
          Quadro.copiadoColumn,
          Quadro.dataColumn,
          Quadro.disciplinaColumn,
          Quadro.anotacaoColumn
        ],
        where: "${Quadro.disciplinaColumn} = ?",
        whereArgs: [id]); // Filtrando a busca pelo ID
    for (Map m in maps) {
      listQuadros.add(Quadro.fromMap(m));
    }
    return listQuadros;
  }

  Future<List> buscaUltimosQuadros(int limit) async {
    Database dbContact = await db;
    List<Quadro> listQuadros = List();
    List<Map> maps = await dbContact.query(
      Quadro.quadroTable,
      columns: [
        Quadro.idColumn,
        Quadro.nameColumn,
        Quadro.imgColumn,
        Quadro.aulaColumn,
        Quadro.copiadoColumn,
        Quadro.dataColumn,
        Quadro.disciplinaColumn,
        Quadro.anotacaoColumn
      ],
      orderBy: "${Quadro.dataColumn} desc",
      limit: limit,
    ); // Filtrando a busca pelo ID
    for (Map m in maps) {
      listQuadros.add(Quadro.fromMap(m));
    }
    return listQuadros;
  }

    Future<List> buscaQuadrosNaoCopiados(int limit) async {
    Database dbContact = await db;
    List<Quadro> listQuadros = List();
    List<Map> maps = await dbContact.query(
      Quadro.quadroTable,
      columns: [
        Quadro.idColumn,
        Quadro.nameColumn,
        Quadro.imgColumn,
        Quadro.aulaColumn,
        Quadro.copiadoColumn,
        Quadro.dataColumn,
        Quadro.disciplinaColumn,
        Quadro.anotacaoColumn
      ],
      orderBy: "${Quadro.dataColumn} desc",
      where: "${Quadro.copiadoColumn} != 1",
      limit: limit,
    ); // Filtrando a busca pelo ID
    for (Map m in maps) {
      listQuadros.add(Quadro.fromMap(m));
    }
    return listQuadros;
  }

  Future<int> pegaTamanho() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery(
        "select count(*) from ${Quadro.quadroTable}")); //Retorna a quantidade de tuplas
  }
}
