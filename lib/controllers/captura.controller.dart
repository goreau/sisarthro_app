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
  var valCodend = ''.obs;
  var valPC = ''.obs;

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
  var tp_codend = '0'.obs;

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
  final valPcController = TextEditingController();

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

    await loadArea();
    await loadAuxiliares();

    final db = DbHelper.instance;
    var json = await db.queryDetail(id);

    await updateArea(json['area'].toString());

    updateQuart(json['quadra'].toString());
    updateMet(json['metodo'].toString());
    updateAmb(json['ambiente'].toString());
    updateCap(json['local_captura'].toString());


    masterId = int.parse(json['id_captura'].toString());
    int tp = int.parse(json['tp_codend'].toString());
    if (tp == 0){
      updateCodend(json['codend'].toString());
    } else {
      valPcController.text = json['codend'].toString();
    }
    capturaDet.value.tp_codend = tp;
    tp_codend.value = tp.toString();
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
      latController.text = pos.latitude.toString();
      lngController.text = pos.longitude.toString();
    });
  }

  loadPreferences() async {
    try {
      equipeController.text = await Storage.recupera('equipe');
      ordemController.text = ordem.toString();
    } catch (e) {}
  }

  doRegister() async {
    captura.value.equipe = equipeController.value.text;

    var dt = dateController.value.text;
    var formattedDate = dt.split('/').reversed.join('-');

    captura.value.dtCaptura = formattedDate;
    captura.value.exec_3 = exec3Controller.value.text;
    captura.value.quadrante = quadranteController.value.text;
    captura.value.obsv = obsController.value.text;

    try {
      Storage.insere('equipe', equipeController.value.text);
    } catch (ex) {}

    Map<String, dynamic> row = new Map();
    row['id_municipio'] = captura.value.idMunicipio;
    row['dt_captura'] = captura.value.dtCaptura;
    row['execucao'] = captura.value.execucao;
    row['exec_3'] = captura.value.exec_3;
    row['zona'] = captura.value.zona;
    row['cod_loc'] = captura.value.cod_loc;
    row['quadrante'] = captura.value.quadrante;
    row['agravo'] = captura.value.agravo;
    row['atividade'] = captura.value.atividade;
    row['equipe'] = captura.value.equipe;
    row['obs'] = captura.value.obsv;
    row['id_usuario'] = captura.value.idUsuario;
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

    if (idCodend.value != ''){
      capturaDet.value.tp_codend = 0;
      capturaDet.value.codend = idCodend.value;
    } else if(valPcController.text != ''){
      capturaDet.value.tp_codend = 1;
      capturaDet.value.codend = valPcController.text;
    } else {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Informe o codend ou o ponto de coleta.'),
          backgroundColor: Colors.red[900],
        ),
      );
      return;
    }


    capturaDet.value.num_arm = ailController.text;
    capturaDet.value.altura = alturaController.text;
    capturaDet.value.amostra = amostraController.text;
    capturaDet.value.quantPotes = tubosController.text;
    capturaDet.value.hora_inicio = horaIni.value;
    capturaDet.value.hora_final = horaFim.value;
    capturaDet.value.temp_inicio = tempIniController.text;
    capturaDet.value.temp_final = tempFimController.text;
    capturaDet.value.umidade_inicio = umidIniController.text;
    capturaDet.value.umidade_final = umidFimController.text;
    capturaDet.value.latitude = latController.text;
    capturaDet.value.longitude = lngController.text;

    Map<String, dynamic> row = new Map();
    row['id_captura'] = masterId;
    row['area'] = capturaDet.value.area;
    row['codend'] = capturaDet.value.codend;
    row['tp_codend'] = capturaDet.value.tp_codend;
    row['quadra'] = capturaDet.value.quadra;
    row['metodo'] = capturaDet.value.metodo;
    row['ambiente'] = capturaDet.value.ambiente;
    row['local_captura'] = capturaDet.value.localCaptura;
    row['num_arm'] = capturaDet.value.num_arm;
    row['altura'] = capturaDet.value.altura == "" ? 0 : capturaDet.value.altura;
    row['amostra'] = capturaDet.value.amostra;
    row['quant_potes'] = capturaDet.value.quantPotes == "" ? 0 : capturaDet.value.quantPotes;
    row['hora_inicio'] = capturaDet.value.hora_inicio;
    row['hora_final'] = capturaDet.value.hora_final;
    row['temp_inicio'] = capturaDet.value.temp_inicio == "" ? 0 : capturaDet.value.temp_inicio;
    row['temp_final'] = capturaDet.value.temp_final == "" ? 0 : capturaDet.value.temp_final;
    row['umidade_inicio'] = capturaDet.value.umidade_inicio == "" ? 0 : capturaDet.value.umidade_inicio;
    row['umidade_final'] = capturaDet.value.umidade_final == "" ? 0 : capturaDet.value.umidade_final;
    row['latitude'] = capturaDet.value.latitude == "" ? 0 : capturaDet.value.latitude;
    row['longitude'] = capturaDet.value.longitude == "" ? 0 : capturaDet.value.longitude;
    row['fant_area'] = capturaDet.value.fantArea;
    row['fant_quart'] = capturaDet.value.fantQuart;
    int id = 0;

    if (editIdDet == 0) {
      id = await dbHelper.insert(row, 'captura_det');
    } else {
      await dbHelper.update(row, 'captura_det', editIdDet);
    }


    if (id > 0) {
      ordem++;
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
      Get.offNamed(Routes.CONSULTA);
    }
  }

  doClear() {
    ordemController.text = ordem.toString();
    alturaController.text = '';
    ailController.text = '';
    amostra.value = '';
    tubos.value = '';
    horaIni.value = '';
    horaFim.value = '';
    tempIni.value = '';
    tempFim.value = '';
    umidIni.value = '';
    umidFim.value = '';
    valCodend.value = '';
    valPC.value = '';
  }

  getCurrentDate(String date) async {
    //var dateParse = DateTime.parse(date);
    var formattedDate = date.split('-').reversed.join('/');
    //var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    dateController.value.text = formattedDate;
    dtCadastro.value = formattedDate.toString();
  }

  loadMun() {
    loadingMun.value = true;
    Auxiliar.loadData('municipio', '').then((value) {
      lstMun.value = value;
      loadingMun.value = false;
    });
  }

  loadAtiv() {
    loadingAtiv.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 3').then((value) {
      lstAtiv.value = value;
      loadingAtiv.value = false;
    });
  }

  loadAgravo() {
    loadingAgravo.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 2 ' ).then((value) {
      lstAgravo.value = value;
      loadingAgravo.value = false;
    });
    loadingZona.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 1 ' ).then((value) {
      lstZona.value = value;
      loadingZona.value = false;
    });
  }

  loadAuxiliares() {
    loadingMet.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 4 ' ).then((value) {
      lstMet.value = value;
      loadingMet.value = false;
    });
    loadingAmb.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 5 ' ).then((value) {
      lstAmb.value = value;
      loadingAmb.value = false;
    });
    loadingCap.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 6 ' ).then((value) {
      lstCap.value = value;
      loadingCap.value = false;
    });
  }


  loadArea() {
    loadingArea.value = true;
    Auxiliar.loadData('area', '').then((value) {
      lstArea.value = value;
      loadingArea.value = false;
    });
  }



  Future updateArea(value) async {
    if (value == 'null') return true;

    loadingQuart.value = true;
    capturaDet.value.area = value;
    
    var fant = lstArea.value.where((e) => e.value == value).toList();
    dynamic txt = fant[0].child;

    capturaDet.value.fantArea = txt.data;
    idArea.value = value;

    await Auxiliar.loadData('quarteirao', ' id_area= ' + value).then((value) {
      lstQuart.value = value;
      loadingQuart.value = false;
    });
  }

  updateMun(value) {
    captura.value.idMunicipio =  int.parse(value);
    idMun.value = value;
    Auxiliar.getProp(int.parse(value)).then((val) => captura.value.idUsuario = val);

    loadingLoc.value = true;
    Auxiliar.loadData('localidade', ' id_municipio= ' + value).then((value) {
      lstLoc.value = value;
      loadingLoc.value = false;
    });
    Auxiliar.loadData('area', ' id_municipio= ' + value).then((value) {
      lstArea.value = value;
    });
  }

  updateAtiv(value) {
    captura.value.atividade = int.parse(value);
    idAtiv.value = value;
  }

  updateZona(value) {
    captura.value.zona = int.parse(value);
    idZona.value = value;
  }

  updateAgravo(value) {
    captura.value.agravo = int.parse(value);
    idAgravo.value = value;
  }

  updateMet(value) {
    capturaDet.value.metodo = int.parse(value);
    idMet.value = value;
  }

  updateAmb(value) {
    capturaDet.value.ambiente = int.parse(value);
    idAmb.value = value;
  }

  updateCap(value) {
    capturaDet.value.localCaptura = int.parse(value);
    idCap.value = value;
  }

  updateMunOld(value) {
 //   this.captura.value.idMunicipio =  int.parse(value);
    idMun.value = value;
    loadingArea.value = true;
    Auxiliar.loadData('area', ' id_municipio= ' + value).then((value) {
      lstArea.value = value;
      loadingArea.value = false;
    });
  }

  updateLoc(value) {
    captura.value.cod_loc = int.parse(value);
    idLoc.value = value;
  }

  updateCodend(value) {
 //   this.captura.value.idCodend = value;
    idCodend.value = value;
  }

  updateQuart(value) {
    if (value == '0') return true;
    var fant = lstQuart.value.where((e) => e.value == value).toList();
    dynamic txt = fant[0].child;
    capturaDet.value.quadra = value;
    capturaDet.value.fantQuart = txt.data;
    idQuart.value = value;
    Auxiliar.loadData('codend', ' id_quarteirao= ' + value).then((value) {
      lstCodend.value = value;
    });
  }

  updateExec(value) {
    value = value == null ? 1 : value;
    captura.value.execucao = value;
    idExecucao.value = value;
  }
}
