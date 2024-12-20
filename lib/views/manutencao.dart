import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/controllers/captura.controller.dart';
import 'package:sisarthro_app/controllers/captura.controller.dart';
import 'package:sisarthro_app/controllers/manutencao.controller.dart';

import '../colors-constants.dart';
import '../controllers/canino.controller.dart';

class ManutencaoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ManutencaoController ctrl = Get.put(ManutencaoController());
    // final CapturaController ctrl = Get.put(CapturaController());
    //  final CaninoController ctrlc = Get.put(CaninoController());

    return Scaffold(
      appBar: AppBar(
        title: Text('MANUTENÇÃO'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Column(
          children: [
            Text('Excluir Registros', style: TextStyle(fontSize: 20)),
            Container(
              height: 2,
              child: Divider(
                color: Colors.blueGrey,
              ),
            ),
            Obx(
              () => CheckboxListTile(
                title: const Text('Cães e Gatos'),
                value: ctrl.chkCao.value,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  ctrl.chkCao.value = value!;
                },
                secondary: const Icon(Icons.pets_outlined),
              ),
            ),
            Obx(
              () => CheckboxListTile(
                title: const Text('Captura'),
                value: ctrl.chkCapt.value,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  ctrl.chkCapt.value = value!;
                },
                secondary: const Icon(Icons.bug_report),
              ),
            ),
            Obx(
              () => CheckboxListTile(
                title: const Text('Tudo'),
                value: ctrl.chkAll.value,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  ctrl.chkAll.value = value!;
                },
                secondary: const Icon(Icons.done_all),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 50),
              child: Row(
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
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
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
                              ctrl.limpaTabelas(context);
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('EXCLUIR REGISTROS',
                      style: TextStyle(color: COR_BRANCO)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: COR_AZUL_MARINHO,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
