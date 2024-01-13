import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/colors-constants.dart';
import 'package:sisarthro_app/controllers/consulta.controller.dart';
import 'package:sisarthro_app/models/captura.dart';
import 'package:sisarthro_app/util/routes.dart';

class ConsultaTile extends StatelessWidget {
  final LstDetail prop;
  final ConsultaController ctrl = Get.put(ConsultaController());

  ConsultaTile(this.prop);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            label: 'Editar',
            backgroundColor: Colors.green,
            icon: Icons.edit,
            onPressed: (context) {
              Get.toNamed(Routes.ATIVIDADE, arguments: prop.id);
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
              ctrl.excluiVisita(prop.id);
            },
          ),
        ],
      ),
      child: ListTile(
        leading: trocaIcone(prop.status),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'Ordem: ',
              ),
              TextSpan(
                  text: '${prop.umidade_final}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'Data: ',
                  ),
                  TextSpan(
                      text: '${prop.endereco}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Icon trocaIcone(int stt) {
    Icon ret;
    switch (stt) {
      case 0:
        ret = Icon(
          Icons.lock_open,
          color: Colors.green,
        );
        break;
      default:
        ret = Icon(
          Icons.lock,
          color: Colors.red,
        );
        break;
    }

    return ret;
  }
}
