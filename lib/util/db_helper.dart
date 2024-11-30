import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sisarthro_app/models/captura.dart';
import 'package:sisarthro_app/models/canino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final _databaseName = "arthro2.db";
  static final _databaseVersion = 7;

  Map registros = Map<String, dynamic>();

  static final sqlCreate = [
    "CREATE TABLE municipio(id_municipio INTEGER, nome TEXT, codigo TEXT, id_prop INTEGER)",
    "CREATE TABLE localidade(id_localidade INTEGER, nome TEXT, codigo TEXT, id_municipio INTEGER)",
    "CREATE TABLE codend(id_codend INTEGER, id_municipio INTEGER, logradouro TEXT, numero TEXT, complemento TEXT, id_area INTEGER, id_quarteirao INTEGER, codigo TEXT, fant_area TEXT, fant_quart TEXT)",
    "CREATE TABLE area(id_area INTEGER, id_municipio INTEGER, codigo TEXT)",
    "CREATE TABLE quarteirao(id_quarteirao INTEGER, id_area INTEGER, numero TEXT)",
    "CREATE TABLE auxiliares(id_auxiliares INTEGER, tipo INTEGER, codigo TEXT, descricao TEXT)",
    "CREATE TABLE raca(id_raca INTEGER, tipo INTEGER, codigo TEXT, nome TEXT)",
    "CREATE TABLE captura(id_captura INTEGER PRIMARY KEY, dt_captura TEXT, execucao INTEGER, exec_3 TEXT, zona INTEGER, id_municipio INTEGER, cod_loc INTEGER, quadrante INTEGER, agravo INTEGER, atividade INTEGER, equipe TEXT, obs TEXT, id_usuario INTEGER, status INTEGER)",
    "CREATE TABLE captura_det(id_captura_det INTEGER PRIMARY KEY, id_captura INTEGER, area INTEGER, quadra INTEGER, codend INTEGER, tp_codend INTEGER, metodo INTEGER, ambiente INTEGER, local_captura INTEGER, num_arm TEXT, altura REAL, hora_inicio TEXT, hora_final TEXT, temp_inicio REAL, temp_final REAL, " +
        "umidade_inicio REAL, umidade_final REAL, amostra TEXT, quant_potes INTEGER, latitude REAL, longitude REAL, fant_area TEXT, fant_quart TEXT, " +
        "FOREIGN KEY (id_captura) REFERENCES captura(id_captura) ON DELETE CASCADE)",
    "CREATE TABLE canino(id_canino INTEGER PRIMARY KEY, id_municipio INTEGER, id_quarteirao INTEGER, fant_quart TEXT, id_codend INTEGER, proprietario TEXT, telefone TEXT, id_area INTEGER, fant_area TEXT, dt_canino TEXT, responsavel TEXT, id_situacao INTEGER, latitude REAL, longitude REAL, id_usuario INTEGER, status INTEGER)",
    "CREATE TABLE canino_det(id_canino_det INTEGER PRIMARY KEY, id_canino INTEGER, nome TEXT, id_especie INTEGER, ra TEXT, nascimento TEXT, id_sexo INTEGER, id_raca INTEGER, id_cor INTEGER, peso REAL, "+
        "FOREIGN KEY (id_canino) REFERENCES canino(id_canino) ON DELETE CASCADE)",
  ];

  /*




   */
  static final tabelas = {
    "municipio",
    "localidade",
    "codend",
    "area",
    "quarteirao",
    "auxiliares",
    "raca",
    "captura",
    "captura_det",
    "canino",
    "canino_det",
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

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
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
    debugPrint('Recriando tabelas');
    await _persiste(db);
    for (var e in tabelas) {
      await db.execute("DROP TABLE IF EXISTS $e");
    }
    await _onCreate(db, newVersion);
    _recupera(db);
    debugPrint('Tabelas recriadas');
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

  Future<Map<String, dynamic>> queryMaster(int id) async {
    Database? db = await instance.database;
    var resultset =
        await db!.query('captura', where: 'id_captura = ?', whereArgs: [id]);
    return resultset[0];
  }

  Future<Map<String, dynamic>> queryDetail(int id) async {
    Database? db = await instance.database;
    var resultset =
    await db!.query('captura_det', where: 'id_captura_det = ?', whereArgs: [id]);
    return resultset[0];
  }

  Future<Map<String, dynamic>> caninoMaster(int id) async {
    Database? db = await instance.database;
    var resultset =
    await db!.query('canino', where: 'id_canino = ?', whereArgs: [id]);
    return resultset[0];
  }

  Future<Map<String, dynamic>> caninoDetail(int id) async {
    Database? db = await instance.database;
    var resultset =
    await db!.query('canino_det', where: 'id_canino_det = ?', whereArgs: [id]);
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
    if (table == 'captura'){
      int res = await db!.delete('captura_det', where: 'id_captura = ?', whereArgs: [id]);
    } else if (table == 'canino'){
      int res = await db!.delete('canino_det', where: 'id_canino = ?', whereArgs: [id]);
    }
    return await db!.delete(table, where: '$idField = ?', whereArgs: [id]);
  }


  Future<int> limpa(String table) async {
    Database? db = await instance.database;
    return await db!.delete(table);
  }

  Future<int> limpaCaptura(int tipo) async {
    Database? db = await instance.database;

      if (tipo == 1) {
        var res = await db!.delete('captura_det');
        return await db!.delete('captura');
      } else {
        var resultset =
        await db!.query('captura', where: 'status = ?', whereArgs: [1]);

        for (var element in resultset) {
          var res = await db!.delete('captura_det', where: 'id_captura = ?',whereArgs: [element['id_captura']]);
        }
        return await db!.delete('captura', where: 'status = ?', whereArgs: [1]);
      }
  }

  Future<int> limpaCanino(int tipo) async {
    Database? db = await instance.database;

    if (tipo == 1) {
      var res = await db!.delete('canino_det');
      return await db!.delete('canino');
    } else {
      var resultset =
      await db!.query('canino', where: 'status = ?', whereArgs: [1]);

      for (var element in resultset) {
        var res = await db!.delete('canino_det', where: 'id_canino = ?',whereArgs: [element['id_canino']]);
      }
      return await db!.delete('canino', where: 'status = ?', whereArgs: [1]);
    }
  }

  Future<void> _persiste(Database db) async {
    //fornecer valor padrão para o campo alterado
    final persTabela = ["municipio", "localidade", "codend", "area", "quarteirao", "auxiliares", "captura", "captura_det"];
    try {
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
    } catch (e) {
      debugPrint('Tabela inexistente');
    }
  }

  Future<List<LstCanMaster>> consultaCaninoMaster() async {
    Database? db = await instance.database;
    var sql =
        'SELECT v.id_canino, v.dt_canino as data, m.nome as municipio, c.codigo as codend, v.fant_quart as quadra, v.status ' +
            'FROM canino v join municipio m on v.id_municipio=m.id_municipio join codend c on c.id_codend=v.id_codend';
    List<Map<String, dynamic>> resultSet = await db!.rawQuery(sql);

    List<LstCanMaster> list = new List.generate(resultSet.length, (index) {
      return LstCanMaster.fromJson(resultSet[index]);
    });

    return list;
  }

  Future<List<LstCanDetail>> consultaCaninoDetail(int id) async {
    Database? db = await instance.database;

    var sql =
        'SELECT v.id_canino_det as id, (CASE v.id_especie WHEN 1 THEN \'Felino\' else \'Canino\' END) as especie, v.nome, r.nome as raca, '+
            '(CASE v.id_sexo WHEN 1 THEN \'Macho\' ELSE \'Fêmea\' END) as sexo ' +
            'FROM canino_det v JOIN raca r on r.id_raca=v.id_raca WHERE v.id_canino=' + id.toString();
    List<Map<String, dynamic>> resultSet =
    await db!.rawQuery(sql);

    List<LstCanDetail> list = new List.generate(resultSet.length, (index) {
      return LstCanDetail.fromJson(resultSet[index]);
    });

    return list;
  }

  Future<List<LstMaster>> consultaCapturasMaster() async {
    Database? db = await instance.database;
    var sql =
        'SELECT v.id_captura, v.dt_captura as data, m.nome as municipio, ag.descricao as agravo, at.descricao as atividade, v.status ' +
            'FROM captura v join municipio m on v.id_municipio=m.id_municipio ' +
                'JOIN auxiliares ag ON ag.id_auxiliares= v.agravo JOIN auxiliares at ON at.id_auxiliares=v.atividade';
    List<Map<String, dynamic>> resultSet = await db!.rawQuery(sql);

    List<LstMaster> list = new List.generate(resultSet.length, (index) {
      return LstMaster.fromJson(resultSet[index]);
    });

    return list;
  }

  Future<List<LstDetail>> consultaVisitasDetail(int id) async {
    Database? db = await instance.database;

    var sql =
        'SELECT v.id_captura_det, q.numero as quadra, v.codend, m.descricao as metodo, a.descricao as ambiente, v.amostra ' +
        'FROM captura_det v left join quarteirao q on v.quadra=q.id_quarteirao JOIN auxiliares m ON v.metodo=m.id_auxiliares ' +
        ' JOIN auxiliares a ON v.ambiente=a.id_auxiliares WHERE v.id_captura=' + id.toString();
    List<Map<String, dynamic>> resultSet =
        await db!.rawQuery(sql);

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

  Future<int> getProp(int mun) async {
    Database? db = await instance.database;
    var prop = 0;
    var resultSet =  await db!.query('municipio', where: 'id_municipio=?', whereArgs: [mun]);

    var dbItem = resultSet.first;
    // Access its id
    prop = int.parse(dbItem['id_prop'].toString());

    return prop;
  }

  Future<List<Map>>
  qryCombo(String tabela, filtro) async {
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
    } else if (tabela == 'raca') {
      sql = "SELECT id_$tabela as id, (codigo || ', ' || nome) as nome FROM $tabela";
    } else {
      sql = "SELECT id_$tabela as id, (codigo || '.' || descricao) as nome FROM $tabela";
    }
    sql += filtro == '' ? ' ORDER BY id' : ' WHERE $filtro ORDER BY id';

    return await db!.rawQuery(sql);
  }

  Future<(int,int)> qryCountEnvio() async {
    Database? db = await instance.database;
    String sql = 'SELECT count(*) as qt FROM captura WHERE status=0';
    var qt = 0;
    var resultSet = await db!.rawQuery(sql);

    var dbItem = resultSet.first;

    sql = 'SELECT count(*) as qt FROM captura_det d JOIN captura c ON c.id_captura=d.id_captura WHERE c.status=0';
    var qtd = 0;
    var resultSetD = await db!.rawQuery(sql);

    var dbItemD = resultSetD.first;
    // Access its id
    qt = int.parse(dbItem['qt'].toString());
    qtd = int.parse(dbItemD['qt'].toString());

    return (qt,qtd);
  }

  Future<List<Map>> qryEnvio() async {
    Database? db = await instance.database;
    var resultSet =
        await db!.query('captura', where: 'status=?', whereArgs: [0]);

    return resultSet;
  }

  Future<List<Map>> qryEnvioDet(int master) async {
    Database? db = await instance.database;
    var resultSet =
    await db!.query('captura_det', where: 'id_captura=?', whereArgs: [master]);

    return resultSet;
  }

  Future<int> updateStatus(linha) async {
    Database? db = await instance.database;

    var result = await db!.update('captura', {'status': linha['status']},
        where: 'id_captura = ?', whereArgs: [linha['id']]);

    return result;
  }
}
