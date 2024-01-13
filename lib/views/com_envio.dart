import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/colors-constants.dart';
import 'package:sisarthro_app/controllers/exporta.controller.dart';

class ComExporta extends StatelessWidget {
  final ExportaController ctrl = Get.put(ExportaController());

  @override
  Widget build(BuildContext context) {
    ctrl.verifEnvio(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Exportar Produção'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 5, 10),
            child: Obx(() {
              return Text(ctrl.retorno.value);
            }),
          ),
          Obx(() {
            return !ctrl.loading.value
                ? Container(
                    padding: EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          ctrl.postVisitas(context);
                        },
                        child: Text('Enviar os Registros'),
                        style: ElevatedButton.styleFrom(primary: COR_AZUL),
                      ),
                    ),
                  )
                : Text('Aguarde...');
          }),
          Obx(() {
            return ctrl.loading.value
                ? Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [CircularProgressIndicator()]),
                  )
                : Text(ctrl.resultado.value);
          })
        ],
      ),
    );
  }
}
