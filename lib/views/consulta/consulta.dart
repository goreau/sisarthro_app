import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/controllers/consulta.controller.dart';
import 'package:sisarthro_app/models/captura.dart';
import 'package:sisarthro_app/util/routes.dart';
import 'package:sisarthro_app/views/consulta/consulta-master.dart';
import '../../colors-constants.dart';

class Consulta extends StatelessWidget {
  final ConsultaController ctrl = Get.put(ConsultaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visitas realizadas'),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.CAPTURA, arguments: 0);
            },
            child: Icon(
              Icons.add,
              color: COR_BRANCO,
            ),
          )
        ],
      ),
      body: Container(
        child: Obx(
          () {
            return ctrl.loaded.value
                ? ListaVisitas(ctrl.itens)
                : Text(
                    'Carregando...',
                    style: TextStyle(color: COR_SECUNDARIA),
                  );
          },
        ),
      ),
    );
  }
}

class ListaVisitas extends StatelessWidget {
  final List<LstMaster> lista;
  ListaVisitas(this.lista);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (ctx, i) => ConsultaMaster(lista[i]),
      ),
    );
  }
}
