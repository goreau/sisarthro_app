class Canino {
  late int idCanino;
  late int idMunicipio;
  late int idQuarteirao;
  late String fantQuart;
  late int idCodend;
  late String dtCanino;
  late String proprietario;
  late String telefone;
  late int idArea;
  late String fantArea;
  late int idSituacao;
  late String responsavel;
  late String latitude;
  late String longitude;
  late int idUsuario;



  void fromJson(dynamic json) {
    idCanino = int.parse(json['id_captura'].toString());
    dtCanino = json['dt_canino'].toString();
    idMunicipio = int.parse(json['id_municipio'].toString());
    fantQuart = json['fant_quart'].toString();
    idQuarteirao = int.parse(json['id_quarteirao'].toString());
    idCodend = int.parse(json['id_codend'].toString());
    proprietario = json['proprietario'];
    telefone = json['obs'];
    idArea = int.parse(json['id_area'].toString());
    fantArea = json['fant_area'].toString();
    idSituacao = int.parse(json['id_situacao'].toString());
    responsavel = json['responsavel'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
  }

  Map toJson() => {
    'id_canino': idCanino,
    'dt_canino': dtCanino,
    'id_municipio': idMunicipio,
    'fant_quart': fantQuart,
    'id_quarteirao': idQuarteirao,
    'id_codend': idCodend,
    'proprietario': proprietario,
    'telefone': telefone,
    'id_area': idArea,
    'fant_area': fantArea,
    'id_situacao': idSituacao,
    'responsavel': responsavel,
    'latitude': latitude,
    'longitude': longitude,
  };
}

class LstCanMaster {
  int idCanino;
  String municipio;
  String data;
  String quadra;
  String codend;
  int status;

  LstCanMaster(
      this.idCanino, this.municipio, this.data, this.quadra, this.codend, this.status);

  factory LstCanMaster.fromJson(dynamic json) {
    //var prop = jsonDecode(json['dados_proposta']);
    var dt = json['data'].toString();
    var dtcapt = dt.split('-').reversed.join('/');
    return LstCanMaster(
      int.parse(json['id_canino'].toString()),
      json['municipio'].toString().trim(),
      dtcapt,
      json['quadra'],
      json['codend'],
      int.parse(json['status'].toString()),
    );
  }
}

class LstCanDetail {
  int id;
  String especie;
  String nome;
  String raca;
  String sexo;

  LstCanDetail(this.id, this.especie, this.nome, this.raca, this.sexo);

  factory LstCanDetail.fromJson(dynamic json) {
    //var prop = jsonDecode(json['dados_proposta']);
    return LstCanDetail(
        int.parse(json['id'].toString()),
        json['especie'].toString(),
        json['nome'].toString(),
        json['raca'].toString(),
        json['sexo'].toString()
    );
  }
}