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
        title: Text('Capturas realizadas'),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.ATIVIDADE, arguments: 0);
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
            child: Text('Capturas Registradas',
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
  final List<LstMaster> lista;
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
