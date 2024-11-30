

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../colors-constants.dart';
import '../controllers/canino.controller.dart';

class Canino extends StatelessWidget {
  final CaninoController ctrl = Get.find();

  final int ano = DateTime
      .parse(new DateTime.now().toString())
      .year;

  final id = Get.arguments;

  @override
  Widget build(BuildContext context) {
    if (id != null) {
      ctrl.initMaster(id);
    }
    ctrl.getPosition();
    ctrl.loadMun();
    ctrl.loadSituacao();

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
                    leading: const Icon(Icons.map_sharp),
                    title: Text(
                      'Município:',
                      style: new TextStyle(
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    subtitle: Obx(
                          () => ((ctrl.loadingMun.value)
                          ? Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<String>(
                        hint: Text(''),
                        value: ctrl.idMun.value,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ctrl.lstMun,
                        onChanged: (value) {
                          ctrl.updateMun(value);
                        },
                      )),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.map_sharp),
                    title: Text(
                      'Área:',
                      style: new TextStyle(
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    subtitle: Obx(
                          () => ((ctrl.loadingArea.value)
                          ? Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<String>(
                        hint: Text(''),
                        value: ctrl.idArea.value,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ctrl.lstArea,
                        onChanged: (value) {
                          ctrl.updateArea(value);
                        },
                      )),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.map_sharp),
                    title: Text(
                      'Quarteirão:',
                      style: new TextStyle(
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    subtitle: Obx(
                          () => ((ctrl.loadingQuart.value)
                          ? Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<String>(
                        hint: Text(''),
                        value: ctrl.idQuart.value,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ctrl.lstQuart,
                        onChanged: (value) {
                          ctrl.updateQuart(value);
                        },
                      )),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.map_sharp),
                    title: Text(
                      'Codend:',
                      style: new TextStyle(
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    subtitle: Obx(
                          () => ((ctrl.loadingCodend.value)
                          ? Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<String>(
                        hint: Text(''),
                        value: ctrl.idCodend.value,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ctrl.lstCodend,
                        onChanged: (value) {
                          ctrl.updateCodend(value);
                        },
                      )),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.map_sharp),
                    title: Text(
                      'Situação:',
                      style: new TextStyle(
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    subtitle: Obx(
                          () => ((ctrl.loadingSituacao.value)
                          ? Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<String>(
                        hint: Text(''),
                        value: ctrl.idSituacao.value,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ctrl.lstSituacao,
                        onChanged: (value) {
                          ctrl.updateSituacao(value);
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
                      controller: ctrl.proprietarioController,
                      decoration: InputDecoration(labelText: 'Proprietário'),
                      validator: (value) {
                        ctrl.canino.value.proprietario = value!;
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
                      controller: ctrl.telefoneController,
                      decoration: InputDecoration(labelText: 'Telefone'),
                      validator: (value) {
                        ctrl.canino.value.telefone = value!;
                        return null;
                      },
                      onSaved: null,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Obx(
                          () => (TextFormField(
                        style: new TextStyle(
                          fontSize: 12,
                        ),
                        readOnly: true,
                        controller: ctrl.dateController.value,
                        decoration:
                        InputDecoration(hintText: 'Data'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'A data é obrigatória!!';
                          } else {
                            return null;
                          }
                        },
                        onSaved: null,
                        onTap: () async {
                          var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(ctrl.dtCanino.value),
                            firstDate: DateTime(ano - 2),
                            lastDate: DateTime(ano + 1),
                          );
                          if (date != null) {
                            await ctrl.getCurrentDate(date.toString().substring(0, 10));
                            date.toString().substring(0, 10);
                          }
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
                      controller: ctrl.responsavelController,
                      decoration: InputDecoration(labelText: 'Responsável'),
                      validator: (value) {
                        ctrl.canino.value.responsavel = value!;
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
                            ctrl.doRegister();
                          },
                          child: Text('PROSSEGUIR',style: TextStyle(color: COR_BRANCO),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: COR_AZUL_MARINHO,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          )),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.cloud),
                    title: Text(
                      'Coordenadas:',
                      style: new TextStyle(
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: TextFormField(
                              style: new TextStyle(
                                fontSize: 12,
                              ),
                              readOnly: true,
                              controller: ctrl.latController,
                              decoration: InputDecoration(labelText: 'Latitude'),
                              validator: (value) {
                                ctrl.canino.value.latitude = value!;
                                return null;
                              },
                              onSaved: null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: TextFormField(
                              style: new TextStyle(
                                fontSize: 12,
                              ),
                              readOnly: true,
                              controller: ctrl.lngController,
                              decoration: InputDecoration(labelText: 'Longitude'),
                              validator: (value) {
                                print(value);
                                ctrl.canino.value.longitude = value!;
                                return null;
                              },
                              onSaved: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])
              ),
            ]
          ),
        )
    );
  }
}