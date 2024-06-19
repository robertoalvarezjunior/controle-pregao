import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:nicolas/database/local_database.dart';
import 'package:nicolas/model/pregao_model.dart';

final class GetDb {
  GetDb();

  late Database db;

  Future<List<PregaoModel>> getPregao() async {
    try {
      db = await LocalDatabase.instance.database;

      final List<Map<String, dynamic>> pregoes = await db.query('Pregao');

      final List<PregaoModel> pregao =
          pregoes.map((e) => PregaoModel.fromMap(e)).toList();

      return pregao;
    } catch (e) {
      throw Exception(e);
    }
  }
}
