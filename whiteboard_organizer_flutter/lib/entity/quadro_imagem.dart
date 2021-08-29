  // Classe para salvar os dados de uma materia
class QuadroImagem {
  // Colunas e tabela do BD
  static final String quadroImagemTable = "quadroImagemTable";
  static final String idColumn = "idColumn";
  static final String idQuadroColumn = "idQuadroColumn";
    static final String imgColumn = "imgColumn";

  int id;
  int idQuadro;
  String img;

  QuadroImagem();

  QuadroImagem.fromMap(Map map){
    this.id = map[idColumn];
    this.idQuadro = map[idQuadroColumn];
    this.img = map[imgColumn];
    
  }

  Map toMap(){
    Map<String, dynamic> map = {
      idColumn: this.id,
      idQuadroColumn: this.idQuadro,
      imgColumn: this.img
    };
    return map;
  }

  String toString(){
    return "QuadroImagem(id: ${this.id}, idQuadro: ${this.idQuadro}, img: ${this.img})";
  }

}