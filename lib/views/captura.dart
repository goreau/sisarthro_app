import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/colors-constants.dart';
import 'package:sisarthro_app/controllers/captura.controller.dart';

class Captura extends StatelessWidget {
  final CapturaController ctrl = Get.find();

  var masterId = 0;
  var id = 0;

  //final masterId = Get.parameters['master'];
  // final id = Get.parameters['detail'];

  @override
  Widget build(BuildContext context) {
    ctrl.getPosition();
    ctrl.loadAuxiliares();
    final Map<String, dynamic> args = Get.arguments;
    masterId = args["master"];
    id = args["detail"];

    if (id != null && id > 0) {
      ctrl.initDetail(id);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('CAPTURAS'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.cloud),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child:Text(
                          'Área:',
                          style: new TextStyle(
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child:Text(
                          'Quarteirão:',
                          style: new TextStyle(
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Obx(
                        () => ((ctrl.loadingArea.value)
                            ? Center(child: CircularProgressIndicator())
                            : DropdownButtonFormField<String>(
                                hint: Text('Área'),
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
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Obx(
                        () => ((ctrl.loadingQuart.value)
                            ? Center(child: CircularProgressIndicator())
                            : DropdownButtonFormField<String>(
                                hint: Text('Quarteirão'),
                                value: ctrl.idQuart.value,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                isExpanded: true,
                                items: ctrl.lstQuart,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  ctrl.updateQuart(value);
                                },
                              )),
                      ),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
                leading: const Icon(Icons.accessibility),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child:Text(
                          'Codend:',
                          style: new TextStyle(
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child:Text(
                          'Ponto de Coleta:',
                          style: new TextStyle(
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Obx(
                                () => ((ctrl.loadingCodend.value)
                                ? Center(child: CircularProgressIndicator())
                                : DropdownButtonFormField<String>(
                              hint: Text('Área'),
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
                      )
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                          style: new TextStyle(
                            fontSize: 12,
                          ),
                          controller: ctrl.valPcController,
                          decoration: InputDecoration(labelText: 'PC'),
                          validator: (value) {
                            ctrl.valPC.value = value!;
                            return null;
                          },
                          onSaved: null,
                        ),
                      ),
                    ),
                  ],
                )),
            ListTile(
              leading: const Icon(Icons.map_sharp),
              title: Text(
                'Método:',
                style: new TextStyle(
                  fontSize: 13,
                ),
                textAlign: TextAlign.start,
              ),
              subtitle: Obx(
                () => ((ctrl.loadingMet.value)
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                        hint: Text(''),
                        value: ctrl.idMet.value,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ctrl.lstMet,
                        onChanged: (value) {
                          ctrl.updateMet(value);
                        },
                      )),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map_sharp),
              title: Text(
                'Ambiente:',
                style: new TextStyle(
                  fontSize: 13,
                ),
                textAlign: TextAlign.start,
              ),
              subtitle: Obx(
                () => ((ctrl.loadingAmb.value)
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                        hint: Text(''),
                        value: ctrl.idAmb.value,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ctrl.lstAmb,
                        onChanged: (value) {
                          ctrl.updateAmb(value);
                        },
                      )),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map_sharp),
              title: Text(
                'Local Captura:',
                style: new TextStyle(
                  fontSize: 13,
                ),
                textAlign: TextAlign.start,
              ),
              subtitle: Obx(
                () => ((ctrl.loadingCap.value)
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                        hint: Text(''),
                        value: ctrl.idCap.value,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ctrl.lstCap,
                        onChanged: (value) {
                          ctrl.updateCap(value);
                        },
                      )),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: Text(
                'Armadilha:',
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
                        controller: ctrl.ailController,
                        decoration: InputDecoration(labelText: 'No AIL'),
                        validator: (value) {
                          ctrl.capturaDet.value.num_arm = value!;
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
                        controller: ctrl.alturaController,
                        decoration: InputDecoration(labelText: 'Altura'),
                        validator: (value) {
                          ctrl.capturaDet.value.altura = value!;
                          return null;
                        },
                        onSaved: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.access_time_outlined),
              title: Text(
                'Hora:',
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
                        controller: ctrl.horaIniController,
                        decoration: InputDecoration(labelText: 'Inicial'),
                        validator: (value) {
                          print(value);
                          ctrl.capturaDet.value.hora_inicio = value!;
                          return null;
                        },
                        onSaved: null,
                        onTap: () async {
                          final TimeOfDay? result = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (result != null) {
                            ctrl.horaIni.value = result.format(context);
                            ctrl.horaIniController.text = (ctrl.horaIni.value);
                          }
                        },
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
                        controller: ctrl.horaFimController,
                        decoration: InputDecoration(labelText: 'Final'),
                        validator: (value) {
                          print(value);
                          ctrl.capturaDet.value.hora_final = value!;
                          return null;
                        },
                        onSaved: null,
                        onTap: () async {
                          final TimeOfDay? result = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (result != null) {
                            ctrl.horaFim.value = result.format(context);
                            ctrl.horaFimController.text = (ctrl.horaFim.value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.face),
              title: Text(
                'Temperatura:',
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
                        controller: ctrl.tempIniController,
                        decoration: InputDecoration(labelText: 'Inicial'),
                        validator: (value) {
                          ctrl.capturaDet.value.temp_inicio = value!;
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
                        controller: ctrl.tempFimController,
                        decoration: InputDecoration(labelText: 'Final'),
                        validator: (value) {
                          print(value);
                          ctrl.capturaDet.value.temp_final = value!;
                          return null;
                        },
                        onSaved: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: Text(
                'Umidade:',
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
                        controller: ctrl.umidIniController,
                        decoration: InputDecoration(labelText: 'Inicial'),
                        validator: (value) {
                          print(value);
                          ctrl.capturaDet.value.umidade_inicio = value!;
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
                        controller: ctrl.umidFimController,
                        decoration: InputDecoration(labelText: 'Final'),
                        validator: (value) {
                          print(value);
                          ctrl.capturaDet.value.umidade_final = value!;
                          return null;
                        },
                        onSaved: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: Text(
                'Coleta:',
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
                        controller: ctrl.amostraController,
                        decoration: InputDecoration(labelText: 'Amostra'),
                        validator: (value) {
                          ctrl.capturaDet.value.amostra = value!;
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
                        controller: ctrl.tubosController,
                        decoration: InputDecoration(labelText: 'Tubos'),
                        validator: (value) {
                          ctrl.capturaDet.value.quantPotes = value!;
                          return null;
                        },
                        onSaved: null,
                      ),
                    ),
                  ),
                ],
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
                          ctrl.capturaDet.value.latitude = value!;
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
                          ctrl.capturaDet.value.longitude = value!;
                          return null;
                        },
                        onSaved: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
