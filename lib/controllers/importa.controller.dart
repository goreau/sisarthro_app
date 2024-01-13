import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisarthro_app/models/municipio.dart';
import 'package:sisarthro_app/util/comunica.service.dart';
import 'package:sisarthro_app/util/municipios.dart';
import 'package:sisarthro_app/util/storage.dart';

class ImportaController extends GetxController {
  var retorno = ''.obs;
  var loading = false.obs;
  var clearAll = false.obs;
  RxInt tipo = 0.obs;

  late List<Municipio> municipioList;

  ComunicaService _com = new ComunicaService();

  @override
  void onInit(){
    super.onInit();
    municipioList = municipios;
  }

  void setSelectedValue(int value) {
    tipo.value = value;
  }

  Future<void> loadCadastro(BuildContext context, int mun) async {
    loading.value = true;
    
    try {
      if (this.tipo.value == 2){
        Storage.insere('id_municipio', mun);
        retorno.value = await _com.getCadastro(context, mun);
      } else {
        retorno.value = await _com.getSistema(context);
      }



    } catch (Exception) {
      retorno.value = 'Erro criando lista:' + Exception.toString();
    }
    loading.value = false;
  }
}
