import 'dart:async';
import 'dart:io';

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

  var lstArea = <DropdownMenuItem<String>>[].obs;
  var lstMun = <DropdownMenuItem<String>>[].obs;
  var lstLoc = <DropdownMenuItem<String>>[].obs;
  var lstCodend = <DropdownMenuItem<String>>[].obs;
  var lstAtiv = <DropdownMenuItem<String>>[].obs;
  var lstAgravo = <DropdownMenuItem<String>>[].obs;
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

  var capturaDet = Captura_det().obs;
  var captura = Captura().obs;

  final dbHelper = DbHelper.instance;

  initObj(int id) async {
    editId = id;
    final db = DbHelper.instance;

    var json = await db.queryObj('captura', id);

    updateArea(json['id_area'].toString());
    updateMun(json['id_municipio'].toString());
    updateQuart(json['id_quarteirao'].toString());
    updateExec(json['idTipo'].toString());

    var dt = json['dt_cadastro'].split('-');
    var formattedDate =
        dt[2] + '-' + dt[1].padLeft(2, '0') + '-' + dt[0].padLeft(2, '0');
    dtCadastro.value = formattedDate; //json['dt_cadastro'];
    dateController.value.text = json['dt_cadastro']; //dtCadastro.value;
    equipeController.text = json['equipe'].toString();
    ordemController.text = json['ordem'].toString();
    ailController.text = json['ail'].toString();
    alturaController.text = json['altura'].toString();
    amostra.value = (json['amostra'].toString());
    tubos.value = (json['tubos'].toString());
    tempIni.value = (json['temp_inicio'].toString());
    tempFim.value = (json['temp_final'].toString());
    horaIni.value = (json['hora_inicio'].toString());
    horaFim.value = (json['hora_final'].toString());
    umidIni.value = (json['umidade_inicio'].toString());
    umidFim.value = (json['umidade_final'].toString());
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
    this.captura.value.dtCaptura = dateController.value.text;
    this.captura.value.execucao = this.idExecucao.value;
    try {
      Storage.insere('equipe', this.equipeController.value.text);
    } catch (ex) {}
    Get.toNamed(Routes.CAPTURA);
  }

  doPost(BuildContext context) async {
    this.captura.value.idMunicipio = await Storage.recupera('id_municipio');
    this.capturaDet.value.num_arm = this.ailController.text;
    this.capturaDet.value.altura = this.alturaController.text;

    this.capturaDet.value.amostra = this.amostra.value;
    this.capturaDet.value.quantPotes = this.tubos.value;
    this.capturaDet.value.hora_inicio = this.horaIni.value;
    this.capturaDet.value.hora_final = this.horaFim.value;
    this.capturaDet.value.temp_inicio = this.tempIni.value;
    this.capturaDet.value.temp_final = this.tempFim.value;
    this.capturaDet.value.umidade_inicio = this.umidIni.value;
    this.capturaDet.value.umidade_final = this.umidFim.value;
    this.capturaDet.value.latitude = this.latController.text;
    this.capturaDet.value.longitude = this.lngController.text;

    Map<String, dynamic> row = new Map();
  /*  row['id_municipio'] = this.captura.value.idMunicipio;
    row['id_area'] = this.captura.value.idArea;
    row['id_codend'] = this.captura.value.idCodend;
    row['id_quarteirao'] = this.captura.value.idQuarteirao;
    row['dt_cadastro'] = this.captura.value.dtCadastro;
    row['equipe'] = this.captura.value.equipe;
    row['observacao'] = this.captura.value.observacao;

    row['ail'] = this.captura.value.num_arm;
    row['altura'] = this.captura.value.altura;
    row['idTipo'] = this.captura.value.idTipo;
    row['amostra'] = this.captura.value.amostra;
    row['tubos'] = this.captura.value.tubos;
    row['hora_inicial'] = this.captura.value.hora_inicio;
    row['hora_final'] = this.captura.value.hora_final;
    row['temp_inicio'] = this.captura.value.temp_inicio;
    row['temp_final'] = this.captura.value.temp_final;
    row['umidade_inicio'] = this.captura.value.umidade_inicio;
    row['umidade_final'] = this.captura.value.umidade_final;
    row['latitude'] = this.captura.value.latitude;
    row['longitude'] = this.captura.value.longitude;
    row['status'] = 0;*/

    int id = 0;

    if (editId == 0) {
      id = await dbHelper.insert(row, 'captura');
    } else {
      await dbHelper.update(row, 'captura', editId);
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
      Get.to(Routes.CONSULTA);
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
    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
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
    this.loadingQuart.value = true;
    this.capturaDet.value.area = value;
    var fant = lstArea.value.where((item) => item.key == value);
    print(fant);
    //this.capturaDet.value.fantArea = fant;
    this.idArea.value = value;
    Auxiliar.loadData('quarteirao', ' id_area= ' + value).then((value) {
      this.lstQuart.value = value;
      this.loadingQuart.value = false;
    });
  }

  updateMun(value) {
  //  this.captura.value.idMunicipio =  int.parse(value);
    this.idMun.value = value;
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
  //  this.captura.value.idAtividade = int.parse(value);
    this.idAtiv.value = value;
  }

  updateAgravo(value) {
 //   this.captura.value.idAgravo = int.parse(value);
    this.idAgravo.value = value;
  }

  updateMet(value) {
 //   this.captura.value.idMetodo = int.parse(value);
    this.idMet.value = value;
  }

  updateAmb(value) {
 //   this.captura.value.idAmbiente = int.parse(value);
    this.idAmb.value = value;
  }

  updateCap(value) {
//    this.captura.value.idLocalCaptura = int.parse(value);
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
//    this.captura.value.idLocalidade = int.parse(value);
    this.idLoc.value = value;
  }

  updateCodend(value) {
 //   this.captura.value.idCodend = value;
    this.idCodend.value = value;
  }

  updateQuart(value) {
 //   this.captura.value.idQuarteirao = value;
    this.idQuart.value = value;
  }

  updateExec(value) {
    value = value == null ? 1 : value;
  //  this.captura.value.idExecucao = value;
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
