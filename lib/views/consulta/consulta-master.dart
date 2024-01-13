import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/controllers/consulta.controller.dart';
import 'package:sisarthro_app/models/captura.dart';

class ConsultaMaster extends StatelessWidget {
  final LstMaster prop;
  final ConsultaController crtl = Get.put(ConsultaController());

  ConsultaMaster(this.prop);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ListTile(
        leading: trocaIcone(prop.status),
        title: RichText(
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
                  text: '${prop.data}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  text: 'Area: ',
                ),
                TextSpan(
                    text: '${prop.municipio}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                  text: 'Quadra: ',
                ),
                TextSpan(
                    text: '${prop.agravo}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ],
      ),
      children: crtl.getDetail(prop.idCaptura),
    );
  }

  CircleAvatar trocaIcone(int stt) {
    CircleAvatar ret;
    switch (stt) {
      case 0:
        ret = CircleAvatar(
          child: Icon(
            Icons.lock_open,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
        );
        break;
      default:
        ret = CircleAvatar(
          child: Icon(
            Icons.lock,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
        );
        break;
    }

    return ret;
  }
}
