import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/models/canino.dart';
import 'package:sisarthro_app/util/db_helper.dart';
import 'package:sisarthro_app/views/cons_canino/consulta-tile.dart';

class ConsCaninoController extends GetxController {
  var loaded = false.obs;
  List<LstCanMaster> itens = [];
  List<LstCanDetail> dets = [];

  ConsCaninoController() {
    inicio();
  }

  Future<void> inicio() async {
    await loadItens();
  }

  Future<void> loadItens() async {
    try {
      final db = DbHelper.instance;

      itens = await db.consultaCaninoMaster();
      loaded.value = true;
    } catch (ex) {
      print('Erro criando lista' + ex.toString());
    }
  }

  Future<List<LstCanDetail>> loadDetails(id) async {
    List<LstCanDetail> dt = [];
    try {
      final db = DbHelper.instance;
      dt = await db.consultaCaninoDetail(id);
    } catch (ex) {
      print('Erro criando lista' + ex.toString());
    }

    return dt;
  }

  excluiVisita(int id, String tab) async {
    final db = DbHelper.instance;
    Get.back(closeOverlays: true);
    int res = await db.delete(id, tab);
    Get.toNamed('/cons_canino');
  }

  List<Widget> getDetail(int id) {
    List<Widget> childs = [];
    loadDetails(id).then((value) {
      value.forEach((element) {
        childs.add(ConsultaTile(element));
      });
      return childs;
    });
    return childs;
  }
}
