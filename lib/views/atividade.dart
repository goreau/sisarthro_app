import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/colors-constants.dart';
import 'package:sisarthro_app/controllers/captura.controller.dart';

class Atividade extends StatelessWidget {
  final CapturaController ctrl = Get.find();
  final int ano = DateTime.parse(new DateTime.now().toString()).year;

  final id = Get.arguments;

  @override
  Widget build(BuildContext context) {
    if (id != null) {
      ctrl.initObj(id);
    }
    ctrl.loadMun();
    ctrl.loadAtiv();
    ctrl.loadAgravo();
    ctrl.loadPreferences();

    return Scaffold(
      appBar: new AppBar(
        title: const Text('Registrar Captura'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Form(
              child: Column(children: <Widget>[
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
                          InputDecoration(hintText: 'Data da Atividade'),
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
                          initialDate: DateTime.parse(ctrl.dtCadastro.value),
                          firstDate: DateTime(ano - 2),
                          lastDate: DateTime(ano + 1),
                        );
                        if (date != null) {
                          await ctrl
                              .getCurrentDate(date.toString().substring(0, 10));
                          date.toString().substring(0, 10);
                        }
                      },
                    )),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.map_sharp),
                  title: Text(
                    'Execução:',
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
                            groupValue: ctrl.idExecucao.value,
                            onChanged: (int? val) {
                              ctrl.setExecucao(val!);
                            },
                          )),
                          Text('Pasteur'),
                        ]),
                        Row(children: [
                          Obx(() => Radio(
                            value: 2,
                            groupValue: ctrl.idExecucao.value,
                            onChanged: (int? val) {
                              ctrl.setExecucao(val!);
                            },
                          )),
                          Text('Município'),
                        ]),
                        Row(children: [
                          Obx(() => Radio(
                            value: 3,
                            groupValue: ctrl.idExecucao.value,
                            onChanged: (int? val) {
                              ctrl.setExecucao(val!);
                            },
                          )),
                        ]),
                        Expanded(child:
                          Obx(() => TextFormField(
                            enabled: ctrl.idExecucao.value == 3,
                            style: new TextStyle(
                              fontSize: 12,
                            ),
                            controller: ctrl.exec3Controller,
                            decoration: InputDecoration(labelText: 'Outras'),
                            validator: (value) {
                              if (value!.isEmpty && ctrl.idExecucao.value == 3) {
                                return 'A Especificação da execução é obrigatória!!';
                              } else {
                                ctrl.captura.value.exec_3 = value;
                                return null;
                              }
                            },
                            onSaved: null,
                          ),),
                        ),
                      ]),
                ),
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
                    leading: const Icon(Icons.accessibility),
                    title: TextFormField(
                      style: new TextStyle(
                        fontSize: 12,
                      ),
                      controller: ctrl.quadranteController,
                      decoration: InputDecoration(labelText: 'Quadrante'),
                      validator: (value) {

                          ctrl.captura.value.quadrante = value!;
                          return null;
                      },
                      onSaved: null,
                    ),
                ),
                ListTile(
                  leading: const Icon(Icons.map_sharp),
                  title: Text(
                    'Localidade:',
                    style: new TextStyle(
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  subtitle: Obx(
                        () => ((ctrl.loadingLoc.value)
                        ? Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                      hint: Text(''),
                      value: ctrl.idLoc.value,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: ctrl.lstLoc,
                      onChanged: (value) {
                        ctrl.updateLoc(value);
                      },
                    )),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.map_sharp),
                  title: Text(
                    'Atividade:',
                    style: new TextStyle(
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  subtitle: Obx(
                        () => ((ctrl.loadingAtiv.value)
                        ? Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                      hint: Text(''),
                      value: ctrl.idAtiv.value,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: ctrl.lstAtiv,
                      onChanged: (value) {
                        ctrl.updateAtiv(value);
                      },
                    )),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.map_sharp),
                  title: Text(
                    'Agravo:',
                    style: new TextStyle(
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  subtitle: Obx(
                        () => ((ctrl.loadingAgravo.value)
                        ? Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                      hint: Text(''),
                      value: ctrl.idAgravo.value,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: ctrl.lstAgravo,
                      onChanged: (value) {
                        ctrl.updateAgravo(value);
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
                      controller: ctrl.equipeController,
                      decoration: InputDecoration(labelText: 'Equipe'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'O nome da equipe é obrigatório!!';
                        } else {
                          ctrl.captura.value.equipe = value;
                          return null;
                        }
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
                    controller: ctrl.obsController,
                    decoration: InputDecoration(labelText: 'Observação'),
                    validator: (value) {

                        ctrl.captura.value.obsv = value!;
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
                    height: 60,
                    child: ElevatedButton(
                        onPressed: () {
                          ctrl.doRegister();
                        },
                        child: Text('Prosseguir',style: TextStyle(color: COR_BRANCO),),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: COR_AZUL_MARINHO,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                          )),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<String>> loadDados(String tab) async {
  await Future.delayed(Duration(seconds: 10), () => print('Tempo ok.'));
  return ['<15', '15-20', '>20'];
}
