import 'package:flutter/material.dart';

import 'db_helper.dart';

class Auxiliar {
  static Future<List<DropdownMenuItem<String>>> loadData(
      String tabela, String filtro) async {
    final db = DbHelper.instance;
    List<DropdownMenuItem<String>> list = [];
    List<Map> ret;
    list.add(DropdownMenuItem<String>(
      child: Text(
        '--Selecione--',
        style: new TextStyle(
          fontSize: 12.0,
        ),
      ),
      value: '0',
    ));
    ret = await db.qryCombo(tabela, filtro);

    ret.map((map) {
      return getDropDownWidget(map);
    }).forEach((element) {
      list.add(element);
    });
    return list;
  }

  static Future<String> checkEnvio() async {
    final db = DbHelper.instance;

    var ret = await db.qryCountEnvio();

    String list = '=> ' +
        (ret > 0
            ? ret.toString() + ' registros a sincronizar'
            : 'Nenhum registro  sincronizar');
    return list;
  }

  static Future<List<Map<dynamic, dynamic>>> loadEnvio() async {
    final db = DbHelper.instance;

    var ret = await db.qryEnvio();
    /* var dados = [];
    ret.forEach((row) => {dados.add(row)});
    var send = jsonEncode(dados);*/

    return ret;
    //send;
  }

  static Future<int> changeStatus(reg) async {
    final db = DbHelper.instance;
    var cont = 0;

    //regs.forEach((element) {
    db.updateStatus(reg).then((value) => cont += value);
    // });

    return cont;
  }

  static DropdownMenuItem<String> getDropDownWidget(Map<dynamic, dynamic> map) {
    return DropdownMenuItem<String>(
      child: Text(
        map['nome'],
        style: new TextStyle(
          fontSize: 12.0,
        ),
      ),
      value: map['id'].toString(),
    );
  }
}
