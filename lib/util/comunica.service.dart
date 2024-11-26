import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'db_helper.dart';

class ComunicaService {
  final dbHelper = DbHelper.instance;

  List<String> entidades = [
    "area",
    "municipio",
    "localidade",
    "codend",
    "quarteirao",
  ];

  Future<List<dynamic>> postVisitas(
      BuildContext context, String dados) async {
    String _url = '';

    //print(dados);
    _url = 'http://10.8.150.23:4000/mobExporta'; //'''http://vigentapi.saude.sp.gov.br/mobExporta';
    var values = {'data': dados};
    final response = await http.post(Uri.parse(_url), body: values);
    var data = [];
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      if (res['status'] == 'ok'){
        data = res['result'];
      }
    } else {
      throw Exception('Falha ao carregar cadastro');
    }
    return data;
  }

  Future<int> postOtherVisitas(
      BuildContext context, Map<dynamic, dynamic> row) async {
    final db = DbHelper.instance;
    String _url = '';

    _url = 'http://vigentapi.saude.sp.gov.br/mobExporta';
    var cont = 0;


    String _row = jsonEncode(row);

    var request = http.MultipartRequest('POST', Uri.parse(_url));
    request.fields['dados'] = _row;
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      var data = jsonDecode(responseString);
      db.updateStatus(data[0]).then((value) {
        cont += value;
        return Future.value(cont);
      });
    } else {
      throw Exception('Falha ao carregar cadastro');
    }
    return 0;
  }

  Future<String> getSistema(BuildContext context) async {
    String _url = '';
    String resumo = 'Registros recebidos:\n';

    _url = 'http://vigentapi.saude.sp.gov.br/mobAuxiliares';

    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final dados = data['dados'];

      await dbHelper.limpa("auxiliares");
      int ct = 0;
      for (var linha in dados) {
          Map<String, dynamic> row = new Map();

          row['id_auxiliares'] = linha['id'];
          row['tipo'] = linha['tipo'];
          row['codigo'] = linha['codigo'].toString().trim();
          row['descricao'] = linha['descricao'].toString().trim();

          await dbHelper.insert(row, "auxiliares");
          ct++;
      }
      resumo += ct > 0 ? 'Dados do sistema: $ct registros\n' : '';

    }
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Dados recebidos.'),
        backgroundColor: Colors.green[900],
      ),
    );
    return resumo;
  }

  Future<String> getCadastro(BuildContext context, int mun) async {
    String _url = '';
    String resumo = 'Registros recebidos:\n';

    _url = 'http://vigentapi.saude.sp.gov.br/mobCadastro/${mun}';

    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final dados = data['dados'];
      var obj = null;

      for (var linha in entidades) {
        for (var idx in dados){

          if (idx.keys.elementAt(0) == linha){
            obj = idx.values.elementAt(0);
            continue;
          }
        }
        if (obj == null) {
          continue;
        }
        await dbHelper.limpa(linha);
        Map<String, dynamic> row = new Map();
        int ct = 0;
        if (linha == 'area') {
          ct = 0;
          for (var campo in obj) {
            row['id_area'] = campo['id_area'];
            row['id_municipio'] = campo['id_municipio'];
            row['codigo'] = campo['codigo'].toString().trim();
            await dbHelper.insert(row, linha);
            ct++;
            //print('$ct areas');
          }
          resumo += ct > 0 ? 'Área: $ct registros\n' : '';
        } else if (linha == 'municipio') {
          ct = 0;
          for (var campo in obj) {
            row['id_municipio'] = campo['id'];
            row['nome'] = campo['nome'];
            row['codigo'] = campo['codigo'].toString().trim();
            row['id_prop'] = campo['id_prop'];
            await dbHelper.insert(row, linha);
            ct++;
          }
          resumo += ct > 0 ? 'Municipio: $ct registros\n' : ''; } else if (linha == 'municipio') {
        } else if (linha == 'localidade') {
          ct = 0;
          for (var campo in obj) {
            row['id_localidade'] = campo['id'];
            row['nome'] = campo['nome'];
            row['codigo'] = campo['codigo'].toString().trim();
            row['id_municipio'] = campo['id_municipio'];
            await dbHelper.insert(row, linha);
            ct++;
          }
          resumo += ct > 0 ? 'Localidade: $ct registros\n' : '';
        } else if (linha == 'codend') {
          ct = 0;
          for (var campo in obj) {
            row['id_codend'] = campo['id'];
            row['logradouro'] = campo['logradouro'].toString().trim();
            row['numero'] = campo['numero'].toString().trim();
            row['complemento'] = campo['complemento'].toString().trim();
            row['codigo'] = campo['codigo'].toString().trim();
            row['fant_area'] = campo['fant_area'].toString().trim();
            row['fant_quart'] = campo['fant_quart'].toString().trim();
            row['id_municipio'] = campo['id_municipio'];
            row['id_area'] = campo['id_area'];
            row['id_quarteirao'] = campo['id_quarteirao'];
            await dbHelper.insert(row, linha);
            ct++;
          }
          resumo += ct > 0 ? 'Codend: $ct registros\n' : '';
        } else if (linha == 'quarteirao') {
          ct = 0;
          for (var campo in obj) {
            row['id_quarteirao'] = campo['id_quarteirao'];
            row['id_area'] = campo['id_area'];
            row['numero'] = campo['numero'].toString().trim();
            await dbHelper.insert(row, linha);
            ct++;
          }
          resumo += ct > 0 ? 'Quarteirão: $ct registros\n' : '';
        }
      }
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Cadastro recebido.'),
          backgroundColor: Colors.green[900],
        ),
      );
    } else {
      throw Exception('Falha ao carregar cadastro');
    }
    return resumo;
  }
}
