import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/models/canino.dart';
import 'package:sisarthro_app/util/routes.dart';
import '../../controllers/cons_canino.controller.dart';

class ConsultaTile extends StatelessWidget {
  final LstCanDetail prop;
  final ConsCaninoController ctrl = Get.put(ConsCaninoController());

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
              Get.toNamed(Routes.CANINODET, arguments: {'detail': data, 'master': 0});
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
              ctrl.excluiVisita(prop.id, 'canino_det');
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
                        text: 'Especie: ',
                      ),
                      TextSpan(
                        text: '${prop.especie}',
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
                    text: 'Nome: ',
                  ),
                  TextSpan(
                      text: '${prop.nome}',
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
                        text: 'Raça: ',
                      ),
                      TextSpan(
                          text: '${prop.raca}',
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
                        text: 'Sexo: ',
                      ),
                      TextSpan(
                        text: '${prop.sexo}',
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
