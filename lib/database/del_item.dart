import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:nicolas/database/local_database.dart';

final class DelItem {
  DelItem();

  late Database db;

  Future<void> deleteItem({required int id}) async {
    db = await LocalDatabase.instance.database;
    await db.transaction(
      (txn) async {
        await txn.rawDelete('DELETE FROM Pregao WHERE id = ?', [id]);
      },
    );
  }
}
