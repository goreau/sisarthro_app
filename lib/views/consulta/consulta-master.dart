import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/colors-constants.dart';
import 'package:sisarthro_app/controllers/consulta.controller.dart';
import 'package:sisarthro_app/models/captura.dart';

import '../../util/routes.dart';

class ConsultaMaster extends StatelessWidget {
  final LstMaster prop;
  final ConsultaController crtl = Get.put(ConsultaController());

  ConsultaMaster(this.prop);

  @override
  Widget build(BuildContext context) {
    return Column(
        children:[
          Slidable(
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  label: 'Editar',
                  backgroundColor: Colors.green,
                  icon: Icons.edit,
                  onPressed: (context) {
                    Get.toNamed(Routes.ATIVIDADE, arguments: prop.idCaptura);
                  },
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  label: 'Excluir',
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  onPressed: (context) {
                    crtl.excluiVisita(prop.idCaptura, 'captura');
                  },
                ),
              ],
            ),
            child: ExpansionTile(
              title: ListTile(
                trailing: trocaIcone(prop.status),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: 'Data: ',
                            ),
                            TextSpan(
                              text: '${prop.data}',
                                style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Município: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                                text: '${prop.municipio}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                ]),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        children: [
                          TextSpan(
                            text: 'Agravo: ',
                          ),
                          TextSpan(
                            text: '${prop.agravo}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey.shade800,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: 'Atividade: ',
                            ),
                            TextSpan(
                                text: '${prop.atividade}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey.shade800,
                                  fontWeight: FontWeight.w400,
                                )),
                          ],
                        ),
                      ),
                  ]),
                ],
              ),
              children: crtl.getDetail(prop.idCaptura),
            )
          ),
          Container(
            height: 2,
            child: Divider(
              color: COR_AZUL_MARINHO,
            ),
          ),
        ]);
  }

  CircleAvatar trocaIcone(int stt) {
    CircleAvatar ret;
    switch (stt) {
      case 0:
        ret = CircleAvatar(
          child: Icon(
            Icons.lock_open,
            color: Colors.green,
          ),
          backgroundColor: Colors.white,
        );
        break;
      default:
        ret = CircleAvatar(
          child: Icon(
            Icons.lock,
            color: Colors.red,
          ),
          backgroundColor: Colors.white,
        );
        break;
    }

    return ret;
  }
}
