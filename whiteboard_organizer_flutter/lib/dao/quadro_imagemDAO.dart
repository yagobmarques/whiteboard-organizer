import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:whiteboard_organizer_flutter/entity/materia.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro_imagem.dart';
import 'package:whiteboard_organizer_flutter/entity/quadro.dart';

class QuadroImagemDAO {
  // Usando o padrão Singleton
  static final QuadroImagemDAO _instance = QuadroImagemDAO.internal();

  factory QuadroImagemDAO() => _instance;

  QuadroImagemDAO.internal();

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
          "CREATE TABLE ${QuadroImagem.quadroImagemTable}(${QuadroImagem.idColumn} INTEGER PRIMARY KEY, "
          "                                 ${QuadroImagem.idQuadroColumn} INTEGER REFERENCES ${Quadro.quadroTable}, "
          "                                 ${QuadroImagem.imgColumn});");
    });
  }

  Future<QuadroImagem> inserirMateriaQuadro(QuadroImagem q) async {
    Database dbContact = await db;
    // insert é uma função pronta do SQLite
    q.id = await dbContact.insert(QuadroImagem.quadroImagemTable, q.toMap());
    return q;
  }

  Future<QuadroImagem> buscaQuadroImagemPeloId(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(QuadroImagem.quadroImagemTable,
        columns: [
          QuadroImagem.idColumn,
          QuadroImagem.idQuadroColumn,
          QuadroImagem.imgColumn
        ],
        where: "${QuadroImagem.idColumn} = ?",
        whereArgs: [id]); // Filtrando a busca pelo ID

    if (maps.length > 0)
      return QuadroImagem.fromMap(
          maps.first); //Usadoo first, mas o BD deve reornar apenas 1
    else
      return null;
  }

  Future<int> removerQuadroImagem(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(QuadroImagem.quadroImagemTable,
        where: "${QuadroImagem.idColumn} = ?",
        whereArgs: [id]); //Filtrando pelo id
  }

  Future<int> alterarQuadroImagem(QuadroImagem q) async {
    Database dbContact = await db;
    return await dbContact.update(QuadroImagem.quadroImagemTable, q.toMap(),
        where: "${QuadroImagem.idColumn} = ?", whereArgs: [q.id]);
  }

  Future<List> buscaImagensPeloQuadro(int id) async {
    Database dbContact = await db;
    List<QuadroImagem> listQuadrosImagens = List();
    List<Map> maps = await dbContact.query(QuadroImagem.quadroImagemTable,
        columns: [
          QuadroImagem.idColumn,
          QuadroImagem.idQuadroColumn,
          QuadroImagem.imgColumn
        ],
        where: "${QuadroImagem.idQuadroColumn} = ?",
        whereArgs: [id]); // Filtrando a busca pelo ID
    for (Map m in maps) {
      listQuadrosImagens.add(QuadroImagem.fromMap(m));
    }
    return listQuadrosImagens;
  }

  Future<int> pegaTamanho() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery(
        "select count(*) from ${QuadroImagem.quadroImagemTable}")); //Retorna a quantidade de tuplas
  }
}
