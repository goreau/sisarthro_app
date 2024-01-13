import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sisarthro_app/models/captura.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final _databaseName = "sisarthro.db";
  static final _databaseVersion = 2;

  Map registros = Map<String, dynamic>();

  // id_captura, dt_captura, execucao, exec_3, zona, id_municipio, cod_loc, quadrante, agravo, atividade, equipe, obs, created_at, updated_at, id_usuario, codigo
  //
  // id_captura_det, id_captura, area, quadra, codend, coordenadas, metodo, ambiente, local_captura, num_arm, altura, hora_inicio, hora_final, temp_inicio, temp_final, umidade_inicio, umidade_final, amostra, quant_potes, fant_area, fant_quart
  //
  //

  //final dbHelper = DatabaseHelper.instance;

  static final sqlCreate = [
    "CREATE TABLE municipio(id_municipio INTEGER, nome TEXT, codigo TEXT, id_prop INTEGER)",
    "CREATE TABLE localidade(id_localidade INTEGER, nome TEXT, codigo TEXT, id_municipio INTEGER)",
    "CREATE TABLE codend(id_codend INTEGER, id_municipio INTEGER, logradouro TEXT, numero TEXT, complemento TEXT, id_area INTEGER, id_quarteirao INTEGER, codigo TEXT, fant_area TEXT, fant_quart TEXT)",
    "CREATE TABLE area(id_area INTEGER, id_municipio INTEGER, codigo TEXT)",
    "CREATE TABLE quarteirao(id_quarteirao INTEGER, id_area INTEGER, numero TEXT)",
    "CREATE TABLE auxiliares(id_auxiliares INTEGER, tipo INTEGER, codigo TEXT, descricao TEXT)",
    "CREATE TABLE captura(id_captura INTEGER PRIMARY KEY, dt_captura TEXT, execucao INTEGER, exec_3 TEXT, zona INTEGER, id_municipio INTEGER, cod_loc INTEGER, quadrante INTEGER, agravo INTEGER, atividade INTEGER, equipe TEXT, obs TEXT, id_usuario INTEGER, status INTEGER)",
    "CREATE TABLE captura_det(id_captura_det INTEGER PRIMARY KEY, id_captura INTEGER, area INTEGER, quadra INTEGER, codend INTEGER, metodo INTEGER, ambiente INTEGER, local_captura INTEGER, num_arm TEXT, altura REAL, hora_inicio TEXT, hora_final TEXT, temp_inicio REAL, temp_final REAL, " +
        "umidade_inicio REAL, umidade_final REAL, amostra TEXT, quant_potes INTEGER, latitude REAL, longitude REAL, fant_area TEXT, fant_quart TEXT)",
  ];
  static final tabelas = {
    "municipio",
    "localidade",
    "codend",
    "area",
    "quarteirao",
    "auxiliares",
    "captura",
    "captura_det",
  };

  // torna esta classe singleton
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();
  // tem somente uma referência ao banco de dados
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    // instancia o db na primeira vez que for acessado
    _database = await _initDatabase();
    return _database;
  }

  // abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onUpgrade: _onUpgrade,
      onCreate: _onCreate,
    );
  }

  Future _onUpgrade(Database db, int version, int newVersion) async {
    await _persiste(db);
    for (var e in tabelas) {
      await db.execute("DROP TABLE IF EXISTS $e");
    }
    await _onCreate(db, newVersion);
    _recupera(db);
  }

  // Código SQL para criar o banco de dados e as tabelas
  Future _onCreate(Database db, int version) async {
    //
    Batch batch = db.batch();
    try {
      sqlCreate.forEach((e) {
        batch.execute(e);
      });
      await batch.commit();
      debugPrint('Tabelas criadas');
    } catch (e) {
      debugPrint('Erro criando tabela $e');
    }
  }

  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  // Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
  // uma lista de valores-chave de colunas.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  Future<Map<String, dynamic>> queryObj(String table, int id) async {
    Database? db = await instance.database;
    var resultset =
        await db!.query(table, where: 'id_captura = ?', whereArgs: [id]);
    return resultset[0];
  }

  Future<int?> queryRowCount(String table) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row, String table, int id) async {
    Database? db = await instance.database;
    String idField = 'id_$table';
    return await db!.update(table, row, where: '$idField = ?', whereArgs: [id]);
  }

  Future<int> delete(int id, String table) async {
    Database? db = await instance.database;
    String idField = 'id_$table';
    return await db!.delete(table, where: '$idField = ?', whereArgs: [id]);
  }

  Future<int> limpa(String table) async {
    Database? db = await instance.database;
    return await db!.delete(table);
  }

  Future<int> limpaCaptura(int tipo) async {
    Database? db = await instance.database;
    if (tipo == 1) {
      return await db!.delete('captura');
    } else {
      return await db!.delete('captura', where: 'status = ?', whereArgs: [1]);
    }
  }

  Future<void> _persiste(Database db) async {
    //fornecer valor padrão para o campo alterado
    final persTabela = ["municipio", "localidade", "codend", "area", "quarteirao", "auxiliares", "captura", "captura_det"];
    for (var element in persTabela) {
      var lista = [];
      await db.query(element).then((value) {
        for (var row in value) {
          //value.forEach((row) {
          lista.add(row);
        } //);
        registros[element] = lista;
      });
    }
  }

  Future<List<LstMaster>> consultaCapturasMaster() async {
    Database? db = await instance.database;
    var sql =
        'SELECT v.dt_cadastro, a.codigo as area, q.id_quarteirao as id_quadra, q.numero as quadra, v.status FROM captura v join area a on v.id_area=a.id_area' +
            ' join quarteirao q on v.id_quarteirao=q.id_quarteirao GROUP BY v.dt_cadastro, a.codigo, q.id_quarteirao, q.numero, v.status';
    List<Map<String, dynamic>> resultSet = await db!.rawQuery(sql);

    List<LstMaster> list = new List.generate(resultSet.length, (index) {
      return LstMaster.fromJson(resultSet[index]);
    });

    return list;
  }

  Future<List<LstDetail>> consultaVisitasDetail(int id) async {
    Database? db = await instance.database;

    List<Map<String, dynamic>> resultSet =
        await db!.query('captura', where: 'id_quarteirao=?', whereArgs: [id]);

    List<LstDetail> list = new List.generate(resultSet.length, (index) {
      return LstDetail.fromJson(resultSet[index]);
    });

    return list;
  }

  _recupera(Database db) async {
    //print(registros);
    final persTabela = [
      "municipio",
      "localidade",
      "codend",
      "area",
      "quarteirao",
      "auxiliares",
      "captura",
      "captura_det"
    ];
    for (var element in persTabela) {
      var tab = registros[element];
      for (var reg in tab) {
        db.insert(element, reg);
      }
    }
  }

  Future<List<Map>> qryCombo(String tabela, filtro) async {
    Database? db = await instance.database;
    String sql;
    if (tabela == 'quarteirao') {
      sql = 'SELECT id_$tabela as id, numero as nome FROM $tabela';
    } else if (tabela == 'area') {
      sql = 'SELECT id_$tabela as id, codigo as nome FROM $tabela';
    } else if (tabela == 'municipio') {
      sql = 'SELECT id_$tabela as id, nome as nome FROM $tabela';
    } else if (tabela == 'localidade') {
      sql = "SELECT id_$tabela as id, (codigo || '.' || nome) as nome FROM $tabela";
    } else if (tabela == 'codend') {
      sql = "SELECT id_$tabela as id, (logradouro || ', ' || numero) as nome FROM $tabela";
    } else {
      sql = "SELECT id_$tabela as id, (codigo || '.' || descricao) as nome FROM $tabela";
    }
    sql += filtro == '' ? ' ORDER BY id' : ' WHERE $filtro ORDER BY id';
    //print(sql);
    return await db!.rawQuery(sql);
  }

  Future<int> qryCountEnvio() async {
    Database? db = await instance.database;
    String sql = 'SELECT count(*) as qt FROM captura WHERE status=0';
    var qt = 0;
    var resultSet = await db!.rawQuery(sql);

    var dbItem = resultSet.first;
    // Access its id
    qt = int.parse(dbItem['qt'].toString());

    return qt;
  }

  Future<List<Map>> qryEnvio() async {
    Database? db = await instance.database;
    var resultSet =
        await db!.query('captura', where: 'status=?', whereArgs: [0]);

    return resultSet;
  }

  Future<int> updateStatus(linha) async {
    Database? db = await instance.database;

    var result = await db!.update('captura', {'status': linha['status']},
        where: 'id_captura = ?', whereArgs: [linha['id']]);

    return result;
  }
}
