class Posto {

  int id;
  String nome;
  String valorAlcool;
  String valorGasolina;
  String resultado;
  String data;

  Posto({this.data});

  Posto.fromMap(Map map) {
    id = map["c_id"];
    nome = map["c_nome"];
    valorAlcool = map["c_valorAlcool"];
    valorGasolina = map["c_valorGasolina"];
    resultado = map["c_resultado"];
    data = map['c_data'];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "c_nome": nome,
      "c_valorAlcool": valorAlcool,
      "c_valorGasolina": valorGasolina,
      "c_resultado": resultado,
      "c_data": data,
    };
    if (id != null) {
      map["c_id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Posto{id: $id, nome: $nome, valorAlcool: $valorAlcool, valorGasolina: $valorGasolina, resultado: $resultado, data: $data}';
  }
}
