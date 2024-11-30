class Canino_det {

  late int idCaninoDet;
  late int idCanino;
  late String nome;
  late int idEspecie;
  late String ra;
  late String nascimento;
  late int idSexo;
  late int idRaca;
  late int idCor;
  late String peso;

  void fromJson(dynamic json) {
    idCaninoDet = int.parse(json['id_canino_det'].toString());
    idCanino = int.parse(json['id_canino'].toString());
    nome = json['nome'].toString();
    idEspecie = int.parse(json['id_especie'].toString());
    ra = json['ra'].toString();
    nascimento = json['nascimento'].toString();
    idSexo = int.parse(json['id_sexo'].toString());
    idRaca = int.parse(json['id_raca'].toString());
    idCor = int.parse(json['id_cor'].toString());
    peso = json['num_arm'].toString();
  }

  Map toJson() => {
    'id_canino_det': idCaninoDet,
    'id_canino': idCanino,
    'nome': nome,
    'id_especie': idEspecie,
    'ra': ra,
    'nascimento': nascimento,
    'id_sexo': idSexo,
    'id_raca': idRaca,
    'id_cor': idCor,
    'peso': peso,
  };
}