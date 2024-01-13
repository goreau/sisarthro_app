class Captura {

  late int idCaptura;
  late String dtCaptura;
  late int execucao;
  late String exec_3;
  late int zona;
  late int idMunicipio;
  late int cod_loc;
  late String quadrante;
  late int agravo;
  late int atividade;
  late String equipe;
  late String obsv = '';
  late int idUsuario;



  void fromJson(dynamic json) {
    idCaptura = int.parse(json['id_captura'].toString());
    dtCaptura = json['dt_captura'];
    execucao = int.parse(json['execucao'].toString());
    exec_3 = json['exec_3'].toString();
    zona = int.parse(json['zona'].toString());
    idMunicipio = int.parse(json['id_municipio'].toString());
    cod_loc = int.parse(json['cod_loc'].toString());
    quadrante = json['quadrante'].toString();
    agravo = int.parse(json['agravo'].toString());
    atividade = int.parse(json['atividade'].toString());
    equipe = json['equipe'];
    obsv = json['obs'];
  }

  Map toJson() => {
    'id_captura': idCaptura,
    'dt_captura': dtCaptura,
    'execucao': execucao,
    'exec_3': exec_3,
    'zona': zona,
    'id_municipio': idMunicipio,
    'cod_loc': cod_loc,
    'quadrante': quadrante,
    'agravo': agravo,
    'atividade': atividade,
    'equipe': equipe,
    'obs': obsv,
  };
}

class LstMaster {
  int idCaptura;
  String municipio;
  String data;
  String agravo;
  String atividade;
  int status;

  LstMaster(
      this.idCaptura, this.municipio, this.data, this.agravo, this.atividade, this.status);

  factory LstMaster.fromJson(dynamic json) {
    //var prop = jsonDecode(json['dados_proposta']);
    return LstMaster(
      int.parse(json['id_captura'].toString()),
      json['municipio'].toString(),
      json['data'].toString(),
      json['agravo'],
      json['atividade'],
      int.parse(json['status'].toString()),
    );
  }
}

class LstDetail {
  int id;
  int status;
  String umidade_final;
  String endereco;

  LstDetail(this.id, this.status, this.umidade_final, this.endereco);

  factory LstDetail.fromJson(dynamic json) {
    //var prop = jsonDecode(json['dados_proposta']);
    return LstDetail(
        int.parse(json['id_visita'].toString()),
        int.parse(json['status'].toString()),
        json['umidade_final'].toString(),
        json['endereco'].toString().trim() +
            ', ' +
            json['numero'].toString().trim());
  }
}