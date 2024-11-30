import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/util/auxiliar.dart';
import 'package:sisarthro_app/util/db_helper.dart';
import 'package:sisarthro_app/util/routes.dart';
import 'package:sisarthro_app/util/storage.dart';
import 'package:sisarthro_app/models/canino.dart';
import 'package:sisarthro_app/models/canino_det.dart';

class CaninoController extends GetxController {
  var editId = 0;
  var editIdDet = 0;
  var masterId = 0;

  var lstQuart = <DropdownMenuItem<String>>[].obs;
  var lstArea = <DropdownMenuItem<String>>[].obs;
  var lstMun = <DropdownMenuItem<String>>[].obs;
  var lstCodend = <DropdownMenuItem<String>>[].obs;
  var lstSituacao = <DropdownMenuItem<String>>[].obs;

  var lstEspecie = <DropdownMenuItem<String>>[].obs;
  var lstSexo = <DropdownMenuItem<String>>[].obs;
  var lstRaca = <DropdownMenuItem<String>>[].obs;
  var lstCor = <DropdownMenuItem<String>>[].obs;

  var idArea = '0'.obs;
  var idMun = '0'.obs;
  var idQuart = '0'.obs;
  var idCodend = '0'.obs;
  var idSituacao = '0'.obs;

  var idEspecie = 0.obs;
  var idSexo = 0.obs;
  var idRaca = '0'.obs;
  var idCor = '0'.obs;

  var loadingArea = false.obs;
  var loadingQuart = false.obs;
  var loadingMun = false.obs;
  var loadingCodend = false.obs;
  var loadingSituacao = false.obs;

  var loadingEspecie = false.obs;
  var loadingSexo = false.obs;
  var loadingRaca = false.obs;
  var loadingCor = false.obs;

  //var ordem = 1;

  var clearAll = false.obs;

  var dtCanino = DateTime.now().toString().substring(0, 10).obs;

  var proprietario = ''.obs;
  var telefone = ''.obs;
  var responsavel = ''.obs;

  var nome = ''.obs;
  var ra = ''.obs;
  var nascimento = ''.obs;
  var peso = ''.obs;

  var dateController = TextEditingController().obs;
  var nascController = TextEditingController().obs;

  final proprietarioController = TextEditingController();
  final telefoneController = TextEditingController();
  final responsavelController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();

  final nomeController = TextEditingController();
  final raController = TextEditingController();
  final nascimentoController = TextEditingController();
  final pesoController = TextEditingController();


  var caninoDet = Canino_det().obs;
  var canino = Canino().obs;

  final dbHelper = DbHelper.instance;


  initMaster(int id) async {
    editId = id;

    final db = DbHelper.instance;

    var json = await db.caninoMaster(id);

    await updateMun(json['id_municipio'].toString());
    await updateArea(json['id_area'].toString());
    await updateQuart(json['id_quarteirao'].toString());
    updateCodend(json['id_codend'].toString());
    updateSituacao(json['id_situacao'].toString());


    var dt = json['dt_canino'];//.split('-');

   // var formattedDate = dt[2] + '-' + dt[1].padLeft(2, '0') + '-' + dt[0].padLeft(2, '0');
    getCurrentDate(dt);
   // dtCadastro.value = formattedDate;
  //  dateController.value.text =  dtCadastro.value;//json['dt_canino'];
    proprietarioController.text = json['proprietario'].toString();
    telefoneController.text = json['telefone'].toString();
    responsavelController.text = json['responsavel'].toString();
    latController.text = json['latitude'].toString();
    lngController.text = json['longitude'].toString();
  }

  initDetail(int id) async {
    editIdDet = id;

    await loadCor();

    final db = DbHelper.instance;
    var json = await db.caninoDetail(id);

    await updateEspecie(json['id_especie'].toString());
    updateSexo(json['id_sexo'].toString());
    updateRaca(json['id_raca'].toString());
    updateCor(json['id_cor'].toString());


    masterId = int.parse(json['id_canino'].toString());

    nomeController.text = json['nome'].toString();
    raController.text = json['ra'].toString();
    nascimentoController.text = json['nascimento'].toString();
    pesoController.text = json['peso'].toString();


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

  doRegister() async {
    var dt = dateController.value.text;
    var formattedDate = dt.split('/').reversed.join('-');

    canino.value.dtCanino = formattedDate;
    canino.value.proprietario = proprietarioController.value.text;
    canino.value.telefone = telefoneController.value.text;
    canino.value.responsavel = responsavelController.value.text;
    canino.value.latitude = latController.text;
    canino.value.longitude = lngController.text;

    Map<String, dynamic> row = new Map();
    row['id_municipio'] = canino.value.idMunicipio;
    row['dt_canino'] = canino.value.dtCanino;
    row['id_area'] = canino.value.idArea;
    row['fant_area'] = canino.value.fantArea;
    row['id_municipio'] = canino.value.idMunicipio;
    row['id_quarteirao'] = canino.value.idQuarteirao;
    row['fant_quart'] = canino.value.fantQuart;
    row['id_codend'] = canino.value.idCodend;
    row['id_situacao'] = canino.value.idSituacao;
    row['dt_canino'] = canino.value.dtCanino;
    row['proprietario'] = canino.value.proprietario;
    row['telefone'] = canino.value.telefone;
    row['responsavel'] = canino.value.responsavel;
    row['latitude'] = canino.value.latitude == "" ? 0 : canino.value.latitude;
    row['longitude'] = canino.value.longitude == "" ? 0 : canino.value.longitude;

    row['status'] = 0;

    if (editId == 0) {
      masterId = await dbHelper.insert(row, 'canino');

      var data = {
        'master': masterId,
        'detail': 0
      };

      Get.toNamed(Routes.CANINODET, arguments: data);
    } else {
      await dbHelper.update(row, 'canino', editId);
      Get.toNamed(Routes.CONS_CANINO);
    }
  }

  doPost(BuildContext context) async {
    caninoDet.value.nome = nomeController.text;
    caninoDet.value.ra = raController.text;
    caninoDet.value.peso = pesoController.text;
    caninoDet.value.nascimento = nascimentoController.text;

    Map<String, dynamic> row = new Map();
    row['id_canino'] = masterId;
    row['nascimento'] = caninoDet.value.nascimento;
    row['peso'] = caninoDet.value.peso;
    row['nome'] = caninoDet.value.nome;
    row['id_especie'] = caninoDet.value.idEspecie;
    row['id_cor'] = caninoDet.value.idCor;
    row['id_raca'] = caninoDet.value.idRaca;
    row['id_sexo'] = caninoDet.value.idSexo;
    row['ra'] = caninoDet.value.ra;

    int id = 0;

    if (editIdDet == 0) {
      id = await dbHelper.insert(row, 'canino_det');
    } else {
      await dbHelper.update(row, 'canino_det', editIdDet);
    }


    if (id > 0) {
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
      Get.offNamed(Routes.CONS_CANINO);
    }
  }

  doClear() {
    nomeController.text = '';
    raController.text = '';
    pesoController.text = '';
    nascimentoController.text = '';
  }

  getCurrentDate(String date) async {
    //var dateParse = DateTime.parse(date);
    var formattedDate = date.split('-').reversed.join('/');
    //var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    dateController.value.text = formattedDate;
    dtCanino.value = formattedDate.toString();
  }

  void setEspecie(int value) {
    idEspecie.value = value;
  }

  void setSexo(int value) {
    idSexo.value = value;
  }

  loadMun() {
    loadingMun.value = true;
    Auxiliar.loadData('municipio', '').then((value) {
      lstMun.value = value;
      loadingMun.value = false;
    });
  }

  loadSituacao() {
    loadingSituacao.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 11').then((value) {
      lstSituacao.value = value;
      loadingSituacao.value = false;
    });
  }

  loadCor() {
    loadingCor.value = true;
    Auxiliar.loadData('auxiliares', 'tipo = 10 ' ).then((value) {
      lstCor.value = value;
      loadingCor.value = false;
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
    canino.value.idArea = int.parse(value.toString());
    
    var fant = lstArea.value.where((e) => e.value == value.toString()).toList();
    dynamic txt = fant[0].child;

    canino.value.fantArea = txt.data;
    idArea.value = value;

    await Auxiliar.loadData('quarteirao', ' id_area= ' + value).then((value) {
      lstQuart.value = value;
      loadingQuart.value = false;
    });
  }

  updateMun(value) async {
    canino.value.idMunicipio =  int.parse(value);
    idMun.value = value;
    Auxiliar.getProp(int.parse(value)).then((val) => canino.value.idUsuario = val);

    loadingArea.value = true;
    await Auxiliar.loadData('area', ' id_municipio= ' + value).then((value) {
      lstArea.value = value;
      loadingArea.value = false;
    });
  }

  updateEspecie(value) async {
    caninoDet.value.idEspecie = int.parse(value.toString());
    idEspecie.value = int.parse(value.toString());

    loadingRaca.value = true;
    await Auxiliar.loadData('raca', 'tipo = $value' ).then((value) {
      lstRaca.value = value;
      loadingRaca.value = false;
    });
  }

  updateSituacao(value) {
    canino.value.idSituacao = int.parse(value);
    idSituacao.value = value;
  }

  updateSexo(value) {
    caninoDet.value.idSexo = int.parse(value.toString());
    idSexo.value = int.parse(value.toString());
  }

  updateCor(value) {
    caninoDet.value.idCor = int.parse(value);
    idCor.value = value;
  }

  updateCodend(value) {
    this.canino.value.idCodend = int.parse(value);
    idCodend.value = value;
  }

  updateQuart(value) async{
    if (value == '0') return true;
    var fant = lstQuart.value.where((e) => e.value == value).toList();
    dynamic txt = fant[0].child;
    canino.value.idQuarteirao = int.parse(value);
    canino.value.fantQuart = txt.data;
    idQuart.value = value;
    await Auxiliar.loadData('codend', ' id_quarteirao= ' + value).then((value) {
      lstCodend.value = value;
    });
  }

  updateRaca(value) {
    caninoDet.value.idRaca = int.parse(value);
    idRaca.value = value;
  }

  limpaCaninos(BuildContext context) async {
    final db = DbHelper.instance;
    var tipo = clearAll.value ? 1 : 2;
    var qt = 0;
    db.limpaCanino(tipo).then((value) {
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
