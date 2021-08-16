  // Classe para salvar os dados de um Quadro
class Quadro {
  // Colunas e tabela do BD
  static final String quadroTable = "quadroTable";
  static final String idColumn = "idColumn";
  static final String nameColumn = "nameColumn";
  static final String imgColumn = "imgColumn";
  static final String disciplinaColumn = "disciplinaColumn";
  static final String aulaColumn = "aulaColumn";
  static final String copiadoColumn = "copiadoColumn";
  static final String dataColumn = "dataColumn";
  static final String anotacaoColumn = "anotacaoColumn";
  

  int id;
  String name;
  String img;
  int disciplina;
  int aula;
  int copiado;
  DateTime data;
  String anotacao;

  Quadro();

  Quadro.fromMap(Map map){
    this.id = map[idColumn];
    this.name = map[nameColumn];
    this.img = map[imgColumn];
    this.disciplina = map[disciplinaColumn];
    this.aula = map[aulaColumn];
    this.copiado= map[copiadoColumn];
    //this.data = map[dataColumn];
    this.anotacao = map[anotacaoColumn];
    
  }

  Map toMap(){
    Map<String, dynamic> map = {
      idColumn: this.id,
      nameColumn: this.name,
      imgColumn: this.img,
      disciplinaColumn: this.disciplina,
      aulaColumn: this.aula,
      copiadoColumn: this.copiado,
      //dataColumn: this.data.toString(),
      anotacaoColumn: this.anotacao
    };
    return map;
  }

  String toString(){
    return "Quadro(id: ${this.id}, name: ${this.name}, img: ${this.img}), disciplina: ${this.disciplina}, aula: ${this.aula}, copiado: ${this.copiado}, data: ${this.data.toString()}, anotacao: ${this.anotacao}";
  }

}