
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../colors-constants.dart';
import '../controllers/canino.controller.dart';

class CaninoDet extends StatelessWidget {
  final CaninoController ctrl = Get.find();

  final int ano = DateTime
      .parse(new DateTime.now().toString())
      .year;

  var masterId = 0;
  var id = 0;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments;
    masterId = args["master"];
    id = args["detail"];

    if (id != null && id > 0) {
      ctrl.initDetail(id);
    }

    ctrl.loadCor();

    return Scaffold(
        appBar: new AppBar(
          title: const Text('CÃES E GATOS'),
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Form(
                      child: Column(children: <Widget>[
                         ListTile(
                          leading: const Icon(Icons.accessibility),
                          title: TextFormField(
                            style: new TextStyle(
                              fontSize: 12,
                            ),
                            controller: ctrl.nomeController,
                            decoration: InputDecoration(labelText: 'Nome'),
                            validator: (value) {
                              ctrl.caninoDet.value.nome = value!;
                              return null;
                            },
                            onSaved: null,
                          ),
                        ),
                       ListTile(
                          leading: const Icon(Icons.map_sharp),
                          title: Text(
                            'Espécie:',
                            style: new TextStyle(
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Obx(() => Radio(
                                    value: 2,
                                    groupValue: ctrl.idEspecie.value,
                                    onChanged: (int? val) {
                                     // ctrl.setEspecie(val!);
                                      ctrl.updateEspecie(val);
                                    },
                                  )),
                                  Text('Canino'),
                                ]),
                                Row(children: [
                                  Obx(() => Radio(
                                    value: 1,
                                    groupValue: ctrl.idEspecie.value,
                                    onChanged: (int? val) {
                                      ctrl.updateEspecie(val);
                                     // ctrl.setEspecie(val!);
                                    },
                                  )),
                                  Text('Felino'),
                                ]),
                              ]),
                        ),
                        ListTile(
                          leading: const Icon(Icons.accessibility),
                          title: TextFormField(
                            style: new TextStyle(
                              fontSize: 12,
                            ),
                            controller: ctrl.raController,
                            decoration: InputDecoration(labelText: 'RA'),
                            validator: (value) {
                              ctrl.caninoDet.value.ra = value!;
                              return null;
                            },
                            onSaved: null,
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.accessibility),
                          title: TextFormField(
                            style: new TextStyle(
                              fontSize: 12,
                            ),
                            controller: ctrl.nascimentoController,
                            decoration: InputDecoration(labelText: 'Ano nascimento'),
                            validator: (value) {
                              ctrl.caninoDet.value.nascimento = value!;
                              return null;
                            },
                            onSaved: null,
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.map_sharp),
                          title: Text(
                            'Sexo:',
                            style: new TextStyle(
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Obx(() => Radio(
                                    value: 1,
                                    groupValue: ctrl.idSexo.value,
                                    onChanged: (int? val) {
                                      ctrl.updateSexo(val!);
                                    },
                                  )),
                                  Text('Macho'),
                                ]),
                                Row(children: [
                                  Obx(() => Radio(
                                    value: 2,
                                    groupValue: ctrl.idSexo.value,
                                    onChanged: (int? val) {
                                      ctrl.updateSexo(val!);
                                    },
                                  )),
                                  Text('Fêmea'),
                                ]),
                              ]),
                        ),
                        ListTile(
                          leading: const Icon(Icons.map_sharp),
                          title: Text(
                            'Raça:',
                            style: new TextStyle(
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          subtitle: Obx(
                                () => ((ctrl.loadingRaca.value)
                                ? Center(child: CircularProgressIndicator())
                                : DropdownButtonFormField<String>(
                              hint: Text(''),
                              value: ctrl.idRaca.value,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items: ctrl.lstRaca,
                              onChanged: (value) {
                                ctrl.updateRaca(value);
                              },
                            )),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.map_sharp),
                          title: Text(
                            'Cor:',
                            style: new TextStyle(
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          subtitle: Obx(
                                () => ((ctrl.loadingCor.value)
                                ? Center(child: CircularProgressIndicator())
                                : DropdownButtonFormField<String>(
                              hint: Text(''),
                              value: ctrl.idCor.value,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items: ctrl.lstCor,
                              onChanged: (value) {
                                ctrl.updateCor(value);
                              },
                            )),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.accessibility),
                          title: TextFormField(
                            style: new TextStyle(
                              fontSize: 12,
                            ),
                            controller: ctrl.pesoController,
                            decoration: InputDecoration(labelText: 'Peso'),
                            validator: (value) {
                              ctrl.caninoDet.value.peso = value!;
                              return null;
                            },
                            onSaved: null,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                ctrl.doPost(context);
                              },
                              child: Text(
                                'SALVAR',
                                style: TextStyle(color: COR_BRANCO),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: COR_AZUL_MARINHO,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])
                  )
                ]
            )
        )
    );
  }
}