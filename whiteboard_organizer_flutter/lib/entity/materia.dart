  // Classe para salvar os dados de uma materia
class Materia {
  // Colunas e tabela do BD
  static final String materiaTable = "materiaTable";
  static final String idColumn = "idColumn";
  static final String nameColumn = "nameColumn";
  static final String imgColumn = "imgColumn";

  int id;
  String name;
  String img;

  Materia();

  Materia.fromMap(Map map){
    this.id = map[idColumn];
    this.name = map[nameColumn];
    this.img = map[imgColumn];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      idColumn: this.id,
      nameColumn: this.name,
      imgColumn: this.img
    };
    return map;
  }

  String toString(){
    return "Materia(id: ${this.id}, name: ${this.name}, img: ${this.img})";
  }

}