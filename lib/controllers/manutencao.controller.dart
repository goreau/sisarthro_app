
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/db_helper.dart';

class ManutencaoController extends GetxController {
  var clearAll = false.obs;
  var chkCao = false.obs;
  var chkCapt = false.obs;
  var chkAll = false.obs;

  limpaTabelas(BuildContext context){
    if (chkAll.value || chkCapt.value){
      limpaCapturas(context);
    }
    if (chkAll.value || chkCao.value){
      limpaCanino(context);
    }
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

  limpaCanino(BuildContext context) async {
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