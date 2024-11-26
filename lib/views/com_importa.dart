import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/colors-constants.dart';
import 'package:sisarthro_app/controllers/importa.controller.dart';
import 'package:sisarthro_app/models/municipio.dart';

class ComImporta extends StatelessWidget {
  final ImportaController ctrl = Get.put(ImportaController());
  int id_mun = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IMPORTAÇÃO'),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(20),
              child: Text('Tipo de Dados',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              )
          ),
          Container(
            height: 2,
            child: Divider(
              color: Colors.blueGrey,
            ),
          ),
          Row(
            children: [
              Expanded(child: ListTile(
                title: const Text('Sistema'),
                leading: Obx(() => Radio(
                  value: 1,
                  groupValue: ctrl.tipo.value,
                  onChanged: (int? val) {
                    ctrl.setSelectedValue(val!);
                  },
                ))
              ),),
              Expanded(child: ListTile(
                  title: const Text('Cadastro'),
                  leading: Obx(() => Radio(
                    value: 2,
                    groupValue: ctrl.tipo.value,
                    onChanged: (int? val) {
                      ctrl.setSelectedValue(val!);
                    },
                  ))
              ),),
            ],
          ),
          Form(
              child: Obx(() =>
                Visibility(
                  visible: ctrl.tipo.value == 2,
                  child:  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: Autocomplete<Municipio>(
                              optionsBuilder: (textEditingValue){
                                return ctrl.municipioList
                                    .where((Municipio mun) => mun.nome
                                    .toLowerCase()
                                    .startsWith(textEditingValue.text.toLowerCase()))
                                    .toList();
                              },
                            displayStringForOption: (Municipio mun) => mun.nome,
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController fieldTextEditingController,
                                FocusNode fieldFocusNode,
                                VoidCallback onFieldSubmitted){
                                  return TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Selecione o município'
                                    ),
                                    controller: fieldTextEditingController,
                                    focusNode: fieldFocusNode,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  );
                                },
                            onSelected: (Municipio sel){
                              id_mun = sel.id_municipios;
                            },
                          ),
                      ),
                      Row(
                        children: [
                          Padding(
                          padding: EdgeInsets.all(16),
                          child:
                          Obx(
                                () => Switch(
                              value: ctrl.clearAll.value,
                              onChanged: (value) {
                                ctrl.clearAll.value = value;
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ),
                          ),
                          Text('Manter os cadastros já existentes.')
                        ],
                      ),
                  ],
                  ),
                ),
              ),
          ),
          Container(
            height: 5,
            child: Divider(
              color: Colors.blue,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Obx(() {
                return !ctrl.loading.value == true
                    ? Container(
                        padding: EdgeInsets.all(20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              ctrl.loadCadastro(context, id_mun);
                            },
                            child: Text('SINCRONIZAR DADOS', style: TextStyle(color: COR_BRANCO),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: COR_AZUL_MARINHO,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text('Aguarde...');
              }),
            ),
          ),
          Obx(() {
            return ctrl.loading.value == true
                ? Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [CircularProgressIndicator()]),
                  )
                : Text(ctrl.retorno.value);
          })
        ],
      ),
    );
  }
}
