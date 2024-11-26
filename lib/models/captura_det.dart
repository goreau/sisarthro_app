class Captura_det {

  late int idCapturaDet;
  late int idCaptura;
  late String area = '0';
  late String quadra = '0';
  late String equipe;
  late String observacao;
  late String codend;
  late int metodo;
  late int ambiente;
  late int localCaptura;
  late String num_arm;
  late String altura;
  late String hora_inicio;
  late String hora_final;
  late String temp_inicio;
  late String temp_final;
  late String umidade_inicio;
  late String umidade_final;
  late String amostra;
  late String quantPotes;
  late String fantArea = '';
  late String fantQuart = '';
  late String latitude;
  late String longitude;

  void fromJson(dynamic json) {
    idCapturaDet = int.parse(json['id_captura_det'].toString());
    idCaptura = int.parse(json['id_captura'].toString());
    area = json['area'].toString();
    quadra = json['quadra'].toString();
    codend = json['codend'].toString();
    metodo = int.parse(json['metodo'].toString());
    ambiente = int.parse(json['ambiente'].toString());
    localCaptura = int.parse(json['local_captura'].toString());
    num_arm = json['num_arm'].toString();
    altura = json['altura'].toString();

    hora_inicio = (json['hora_inicio'].toString());
    hora_final = (json['hora_final'].toString());
    temp_inicio = (json['temp_inicio'].toString());
    temp_final = (json['temp_final'].toString());
    umidade_inicio = (json['umidade_inicio'].toString());
    umidade_final = json['umidade_final'].toString();
    amostra = (json['amostra'].toString());
    quantPotes = (json['quant_potes'].toString());
    fantArea = json['fant_area'].toString();
    fantQuart = json['fant_quart'];

    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
  }
//id_captura_det, id_captura, area, quadra, codend, coordenadas, metodo, ambiente, local_captura, num_arm, altura, hora_inicio, hora_final,
  //temp_inicio, temp_final, umidade_inicio, umidade_final, amostra, quant_potes, fant_area, fant_quart

  Map toJson() => {
    'id_captura_det': idCapturaDet,
    'id_captura': idCaptura,
    'area': area,
    'quadra': quadra,
    'codend': codend,
    'metodo': metodo,
    'ambiente': ambiente,
    'local_captura': localCaptura,
    'num_arm': num_arm,
    'altura': altura,
    'hora_inicio': hora_inicio,
    'hora_final': hora_final,
    'temp_inicio': temp_inicio,
    'temp_final': temp_final,
    'umidade_inicio': umidade_inicio,
    'umidade_final': umidade_final,
    'amostra': amostra,
    'quant_potes': quantPotes,
    'fant_area': fantArea,
    'fant_quart': fantQuart,

    'latitude': latitude,
    'longitude': longitude,
  };
}