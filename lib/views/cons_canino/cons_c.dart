import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/controllers/cons_canino.controller.dart';
import 'package:sisarthro_app/models/canino.dart';
import 'package:sisarthro_app/util/routes.dart';
import 'package:sisarthro_app/views/cons_canino/consulta-master.dart';
import '../../colors-constants.dart';

class Cons_Canino extends StatelessWidget {
  final ConsCaninoController ctrl = Get.put(ConsCaninoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CÃES E GATOS'),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.CANINO, arguments: 0);
            },
            child: Icon(
              Icons.add,
              color: COR_BRANCO,
            ),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
          padding: EdgeInsets.all(20),
            child: Text('Cães e gatos Registrados',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            )
        ),
        Container(
          height: 2,
          child: Divider(
            color: Colors.blueGrey,
          ),
        ),
        Container(
          child: Obx(() {
            return ctrl.loaded.value
                ? ListaVisitas(ctrl.itens)
                : Text(
                    'Carregando...',
                    style: TextStyle(color: COR_SECUNDARIA),
                  );
            },
          ),
        ),
      ]),
    );
  }
}

class ListaVisitas extends StatelessWidget {
  final List<LstCanMaster> lista;
  ListaVisitas(this.lista);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(

        child: ListView.builder(
          itemCount: lista.length,
          itemBuilder: (ctx, i) => ConsultaMaster(lista[i]),
        ),
      ),
    );
  }
}
