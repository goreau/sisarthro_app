import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/util/auxiliar.dart';
import 'package:sisarthro_app/util/db_helper.dart';
import 'package:sisarthro_app/util/routes.dart';
import 'package:sisarthro_app/util/storage.dart';
import 'package:sisarthro_app/models/captura.dart';
import 'package:sisarthro_app/models/captura_det.dart';

class CapturaController extends GetxController {
  var editId = 0;
  var editIdDet = 0;
  var masterId = 0;

  var lstArea = <DropdownMenuItem<String>>[].obs;
  var lstMun = <DropdownMenuItem<String>>[].obs;
  var lstLoc = <DropdownMenuItem<String>>[].obs;
  var lstCodend = <DropdownMenuItem<String>>[].obs;
  var lstAtiv = <DropdownMenuItem<String>>[].obs;
  var lstAgravo = <DropdownMenuItem<String>>[].obs;
  var lstZona = <DropdownMenuItem<String>>[].obs;
  var lstMet = <DropdownMenuItem<String>>[].obs;
  var lstAmb = <DropdownMenuItem<String>>[].obs;
  var lstCap = <DropdownMenuItem<String>>[].obs;
  var lstQuart = <DropdownMenuItem<String>>[].obs;
  var lstTipo = <DropdownMenuItem<String>>[].obs;
  var idArea = '0'.obs;
  var idMun = '0'.obs;
  var idLoc = '0'.obs;
  var idCodend = '0'.obs;
  var idAtiv = '0'.obs;
  var idAgravo = '0'.obs;
  var idZona = '0'.obs;
  var idMet = '0'.obs;
  var idAmb = '0'.obs;
  var idCap = '0'.obs;
  var idQuart = '0'.obs;

  var loadingArea = false.obs;
  var loadingMun = false.obs;
  var loadingLoc = false.obs;
  var loadingCodend = false.obs;
  var loadingAtiv = false.obs;
  var loadingAgravo = false.obs;
  var loadingZona = false.obs;
  var loadingMet = false.obs;
  var loadingAmb = false.obs;
  var loadingCap = false.obs;
  var loadingQuart = false.obs;
  var ordem = 1;

  var clearAll = false.obs;

  var dtCadastro = DateTime.now().toString().substring(0, 10).obs;

  var idExecucao = 1.obs;
  var exec_3 = ''.obs;
  var amostra = ''.obs;
  var tubos = ''.obs;
  var horaIni = ''.obs;
  var horaFim = ''.obs;
  var tempIni = ''.obs;
  var tempFim = ''.obs;
  var umidIni = ''.obs;
  var umidFim = ''.obs;
  var codend = ''.obs;


  var dateController = TextEditingController().obs;

  final exec3Controller = TextEditingController();
  final quadranteController = TextEditingController();

  final equipeController = TextEditingController();
  final obsController = TextEditingController();
  final ordemController = TextEditingController();
  final ailController = TextEditingController();
  final alturaController = TextEditingController();
  final amostraController = TextEditingController();
  final tubosController = TextEditingController();
  final horaIniController = TextEditingController();
  final horaFimController = TextEditingController();
  final tempIniController = TextEditingController();
  final tempFimController = TextEditingController();
  final umidIniController = TextEditingController();
  final umidFimController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  final codendController = TextEditingController();

  var capturaDet = Captura_det().obs;
  var captura = Captura().obs;

  final dbHelper = DbHelper.instance;

  initMaster(int id) async {
    editId = id;

    final db = DbHelper.instance;

    var json = await db.queryMaster(id);

    updateMun(json['id_municipio'].toString());
    updateExec(int.parse(json['execucao'].toString()));
    updateLoc(json['cod_loc'].toString());
    updateAtiv(json['atividade'].toString());
    updateZona(json['zona'].toString());
    updateAgravo(json['agravo'].toString());

    var dt = json['dt_captura'];//.split('-');

   // var formattedDate = dt[2] + '-' + dt[1].padLeft(2, '0') + '-' + dt[0].padLeft(2, '0');
    getCurrentDate(dt);
   // dtCadastro.value = formattedDate;
  //  dateController.value.text =  dtCadastro.value;//json['dt_captura'];
    equipeController.text = json['equipe'].toString();
    quadranteController.text = json['quadrante'].toString();
    obsController.text = json['obs'].toString();
  }

  initDetail(int id) async {
    editIdDet = id;

    loadArea();
    loadAuxiliares();

    final db = DbHelper.instance;
    var json = await db.queryDetail(id);

    updateArea(json['area'].toString());
    updateQuart(json['quadra'].toString());
    updateMet(json['metodo'].toString());
    updateAmb(json['ambiente'].toString());
    updateCap(json['local_captura'].toString());

    masterId = int.parse(json['id_captura'].toString());
    codendController.text = json['codend'].toString();
    ailController.text = json['num_arm'].toString();
    alturaController.text = json['altura'].toString();
    amostraController.text = json['amostra'].toString();
    tubosController.text = json['quant_potes'].toString();
    tempIniController.text = json['temp_inicio'].toString();
    tempFimController.text = json['temp_final'].toString();
    horaIni.value = json['hora_inicio'].toString();
    horaIniController.text = horaIni.value;
    horaFim.value = json['hora_final'].toString();
    horaFimController.text = horaFim.value;
    umidIniController.text = json['umidade_inicio'].toString();
    umidFimController.text = json['umidade_final'].toString();
    latController.text = json['latitude'].toString();
    lngController.text = json['longitude'].toString();
  }

  void setExecucao(int value) {
    idExecucao.value = value;
  }

  Future<void> getPosition() async {
    /* Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    this.latController.text = pos.latitude.toString();
    this.lngController.text = pos.longitude.toString();*/
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    StreamSubscription positionStream =
    await Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position pos) {
      this.latController.text = pos.latitude.toString();
      this.lngController.text = pos.longitude.toString();
    });
  }

  loadPreferences() async {
    try {
      this.equipeController.text = await Storage.recupera('equipe');
      this.ordemController.text = this.ordem.toString();
    } catch (e) {}
  }

  doRegister() async {
    this.captura.value.equipe = this.equipeController.value.text;

    var dt = dateController.value.text;
    var formattedDate = dt.split('/').reversed.join('-');

    this.captura.value.dtCaptura = formattedDate;
    this.captura.value.exec_3 = this.exec3Controller.value.text;
    this.captura.value.quadrante = this.quadranteController.value.text;
    this.captura.value.obsv = this.obsController.value.text;

    try {
      Storage.insere('equipe', this.equipeController.value.text);
    } catch (ex) {}

    Map<String, dynamic> row = new Map();
    row['id_municipio'] = this.captura.value.idMunicipio;
    row['dt_captura'] = this.captura.value.dtCaptura;
    row['execucao'] = this.captura.value.execucao;
    row['exec_3'] = this.captura.value.exec_3;
    row['zona'] = this.captura.value.zona;
    row['cod_loc'] = this.captura.value.cod_loc;
    row['quadrante'] = this.captura.value.quadrante;
    row['agravo'] = this.captura.value.agravo;
    row['atividade'] = this.captura.value.atividade;
    row['equipe'] = this.captura.value.equipe;
    row['obs'] = this.captura.value.obsv;
    row['id_usuario'] = this.captura.value.idUsuario;
    row['status'] = 0;

    if (editId == 0) {
      masterId = await dbHelper.insert(row, 'captura');

      var data = {
        'master': masterId,
        'detail': 0
      };

      Get.toNamed(Routes.CAPTURA, arguments: data);
    } else {
      await dbHelper.update(row, 'captura', editId);
      Get.toNamed(Routes.CONSULTA);
    }


  }

  doPost(BuildContext context) async {
    this.capturaDet.value.codend = this.codendController.text;
    this.capturaDet.value.num_arm = this.ailController.text;
    this.capturaDet.value.altura = this.alturaController.text;
    this.capturaDet.value.amostra = this.amostraController.text;
    this.capturaDet.value.quantPotes = this.tubosController.text;
    this.capturaDet.value.hora_inicio = this.horaIni.value;
    this.capturaDet.value.hora_final = this.horaFim.value;
    this.capturaDet.value.temp_inicio = this.tempIniController.text;
    this.capturaDet.value.temp_final = this.tempFimController.text;
    this.capturaDet.value.umidade_inicio = this.umidIniController.text;
    this.capturaDet.value.umidade_final = this.umidFimController.text;
    this.capturaDet.value.latitude = this.latController.text;
    this.capturaDet.value.longitude = this.lngController.text;

    Map<String, dynamic> row = new Map();
    row['id_captura'] = masterId;
    row['area'] = this.capturaDet.value.area;
    row['codend'] = this.capturaDet.value.codend;
    row['quadra'] = this.capturaDet.value.quadra;
    row['metodo'] = this.capturaDet.value.metodo;
    row['ambiente'] = this.capturaDet.value.ambiente;
    row['local_captura'] = this.capturaDet.value.localCaptura;
    row['num_arm'] = this.capturaDet.value.num_arm;
    row['altura'] = this.capturaDet.value.altura == "" ? 0 : this.capturaDet.value.altura;
    row['amostra'] = this.capturaDet.value.amostra;
    row['quant_potes'] = this.capturaDet.value.quantPotes == "" ? 0 : this.capturaDet.value.quantPotes;
    row['hora_inicio'] = this.capturaDet.value.hora_inicio;
    row['hora_final'] = this.capturaDet.value.hora_final;
    row['temp_inicio'] = this.capturaDet.value.temp_inicio == "" ? 0 : this.capturaDet.value.temp_inicio;
    row['temp_final'] = this.capturaDet.value.temp_final == "" ? 0 : this.capturaDet.value.temp_final;
    row['umidade_inicio'] = this.capturaDet.value.umidade_inicio == "" ? 0 : this.capturaDet.value.umidade_inicio;
    row['umidade_final'] = this.capturaDet.value.umidade_final == "" ? 0 : this.capturaDet.value.umidade_final;
    row['latitude'] = this.capturaDet.value.latitude == "" ? 0 : this.capturaDet.value.latitude;
    row['longitude'] = this.capturaDet.value.longitude == "" ? 0 : this.capturaDet.value.longitude;
    row['fant_area'] = this.capturaDet.value.fantArea;
    row['fant_quart'] = this.capturaDet.value.fantQuart;
    int id = 0;

    if (editIdDet == 0) {
      id = await dbHelper.insert(row, 'captura_det');
    } else {
      await dbHelper.update(row, 'captura_det', editIdDet);
    }


    if (id > 0) {
      this.ordem++;
      doClear();
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Registro inserido.'),
          backgroundColor: Colors.green[900],
        ),
      );
    } else {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Registro atualizado.'),
          backgroundColor: Colors.green[900],
        ),
      );
      Get.toNamed(Routes.CONSULTA);
    }
  }

  doClear() {
    this.ordemController.text = this.ordem.toString();
    this.alturaController.text = '';
    this.ailController.text = '';
    this.amostra.value = '';
    this.tubos.value = '';
    this.horaIni.value = '';
    this.horaFim.value = '';
    this.tempIni.value = '';
    this.tempFim.value = '';
    this.umidIni.value = '';
    this.umidFim.value = '';

  }

  getCurrentDate(String date) async {
    //var dateParse = DateTime.parse(date);
    var formattedDate = date.split('-').reversed.join('/');
    //var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    this.dateController.value.text = formattedDate;
    this.dtCadastro.value = formattedDate.toString();
  }

  loadMun() {
    this.loadingMun.value = true;
    Auxiliar.loadData('municipio', '').then((value) {
      this.lstMun.value = value;
      this.loadingMun.value = false;
    });
  }

  loadAtiv() {
    this.loadingAtiv.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 3').then((value) {
      this.lstAtiv.value = value;
      this.loadingAtiv.value = false;
    });
  }

  loadAgravo() {
    this.loadingAgravo.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 2 ' ).then((value) {
      this.lstAgravo.value = value;
      this.loadingAgravo.value = false;
    });
    this.loadingZona.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 1 ' ).then((value) {
      this.lstZona.value = value;
      this.loadingZona.value = false;
    });
  }

  loadAuxiliares() {
    this.loadingMet.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 4 ' ).then((value) {
      this.lstMet.value = value;
      this.loadingMet.value = false;
    });
    this.loadingAmb.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 5 ' ).then((value) {
      this.lstAmb.value = value;
      this.loadingAmb.value = false;
    });
    this.loadingCap.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 6 ' ).then((value) {
      this.lstCap.value = value;
      this.loadingCap.value = false;
    });
  }


  loadArea() {
    this.loadingArea.value = true;
    Auxiliar.loadData('area', '').then((value) {
      this.lstArea.value = value;
      this.loadingArea.value = false;
    });
  }



  updateArea(value) {
    if (value == 'null') return true;

    this.loadingQuart.value = true;
    this.capturaDet.value.area = value;
    
    var fant = lstArea.value.where((e) => e.value == value).toList();
    dynamic txt = fant[0].child;

    this.capturaDet.value.fantArea = txt.data;
    this.idArea.value = value;
    Auxiliar.loadData('quarteirao', ' id_area= ' + value).then((value) {
      this.lstQuart.value = value;
      this.loadingQuart.value = false;
    });
  }

  updateMun(value) {
    this.captura.value.idMunicipio =  int.parse(value);
    this.idMun.value = value;
    Auxiliar.getProp(int.parse(value)).then((val) => this.captura.value.idUsuario = val);

    this.loadingLoc.value = true;
    Auxiliar.loadData('localidade', ' id_municipio= ' + value).then((value) {
      this.lstLoc.value = value;
      this.loadingLoc.value = false;
    });
    Auxiliar.loadData('area', ' id_municipio= ' + value).then((value) {
      this.lstArea.value = value;
    });
    Auxiliar.loadData('codend', ' id_municipio= ' + value).then((value) {
      this.lstCodend.value = value;
    });

  }

  updateAtiv(value) {
    this.captura.value.atividade = int.parse(value);
    this.idAtiv.value = value;
  }

  updateZona(value) {
    this.captura.value.zona = int.parse(value);
    this.idZona.value = value;
  }

  updateAgravo(value) {
    this.captura.value.agravo = int.parse(value);
    this.idAgravo.value = value;
  }

  updateMet(value) {
    this.capturaDet.value.metodo = int.parse(value);
    this.idMet.value = value;
  }

  updateAmb(value) {
    this.capturaDet.value.ambiente = int.parse(value);
    this.idAmb.value = value;
  }

  updateCap(value) {
    this.capturaDet.value.localCaptura = int.parse(value);
    this.idCap.value = value;
  }

  updateMunOld(value) {
 //   this.captura.value.idMunicipio =  int.parse(value);
    this.idMun.value = value;
    this.loadingArea.value = true;
    Auxiliar.loadData('area', ' id_municipio= ' + value).then((value) {
      this.lstArea.value = value;
      this.loadingArea.value = false;
    });
  }

  updateLoc(value) {
    this.captura.value.cod_loc = int.parse(value);
    this.idLoc.value = value;
  }

  updateCodend(value) {
 //   this.captura.value.idCodend = value;
    this.idCodend.value = value;
  }

  updateQuart(value) {
    if (value == '0') return true;
    var fant = lstQuart.value.where((e) => e.value == value).toList();
    dynamic txt = fant[0].child;
    this.capturaDet.value.quadra = value;
    this.capturaDet.value.fantQuart = txt.data;
    this.idQuart.value = value;
  }

  updateExec(value) {
    value = value == null ? 1 : value;
    this.captura.value.execucao = value;
    this.idExecucao.value = value;
  }

  limpaCapturas(BuildContext context) async {
    final db = DbHelper.instance;
    var tipo = clearAll.value ? 1 : 2;
    var qt = 0;
    db.limpaCaptura(tipo).then((value) {
      qt = value;
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(qt.toString() + ' registros excluidos.'),
          backgroundColor: Colors.green[900],
        ),
      );
    });
  }
}
