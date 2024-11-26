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
              var data = prop.id;
              Get.toNamed(Routes.CAPTURA, arguments: {'detail': data, 'master': 0});
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
              ctrl.excluiVisita(prop.id, 'captura_det');
            },
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 2,
            child: Divider(
              color: Colors.blueGrey,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                child:
                  RichText(
                    text: TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey,
                    ),
                    children: [
                      TextSpan(
                        text: 'CodEnd/PC: ',
                      ),
                      TextSpan(
                        text: '${prop.codend}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ]),
                  ),
              ),
              RichText(
            text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blueGrey,
                ),
                children: [
                  TextSpan(
                    text: 'Método: ',
                  ),
                  TextSpan(
                      text: '${prop.metodo}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blueGrey,
                      )),
                ]),
          ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:[
              RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey,
                    ),
                    children: [
                      TextSpan(
                        text: 'Ambiente: ',
                      ),
                      TextSpan(
                          text: '${prop.ambiente}',
                      ),
                    ]),
              ),
              RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey,
                    ),
                    children: [
                      TextSpan(
                        text: 'Amostra: ',
                      ),
                      TextSpan(
                        text: '${prop.amostra}',
                      ),
                    ]),
              ),
    ]),
        ]
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
