import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/controllers/captura.controller.dart';
import 'package:sisarthro_app/controllers/captura.controller.dart';

import '../colors-constants.dart';

class ManutencaoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CapturaController ctrl = Get.put(CapturaController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Manutenção'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Column(
          children: [
            Text('Excluir Registros'),
            Row(
              children: [
                Obx(
                  () => Switch(
                    value: ctrl.clearAll.value,
                    onChanged: (value) {
                      value
                          ? showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(
                                  'Excluir tudo?',
                                  style: new TextStyle(
                                      fontSize: 20,
                                      color: COR_AZUL_MARINHO,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                    'Isso irá ecluir registros não sincronizados com a base de dados. \r\n Confirma a operação?'),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Não'),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Sim'),
                                    onPressed: () {
                                      ctrl.clearAll.value = value;
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            )
                          : ctrl.clearAll.value = value;
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ),
                Text('Todos os registros.')
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(
                        'Excluir registros?',
                        style: new TextStyle(
                            fontSize: 20,
                            color: COR_AZUL_MARINHO,
                            fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                          'Essa ação não poderá ser desfeita. Confirma a operação?'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Não'),
                          onPressed: () {
                            ctrl.clearAll.value = false;
                            Get.back();
                          },
                        ),
                        TextButton(
                          child: Text('Sim'),
                          onPressed: () {
                            ctrl.limpaCapturas(context);
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Limpar'),
                style: ElevatedButton.styleFrom(primary: COR_AZUL),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
