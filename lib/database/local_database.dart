import 'package:path/path.dart' as p;
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final class LocalDatabase {
  LocalDatabase._();

  static final LocalDatabase instance = LocalDatabase._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;
    var context = p.Context(style: Style.windows);

    var dbPath = context.join('pregao', 'pregao.db');

    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        onCreate: _onCreate,
        version: 1,
      ),
    );
  }

  Future<void> _onCreate(Database database, int version) async {
    final db = database;
    await db.execute(_pregao);
  }

  String get _pregao => '''
    CREATE TABLE Pregao (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orgao TEXT,
      numPregao TEXT,
      dataInicial TEXT,
      dataFinal TEXT,
      assinado INTEGER,
      dataAssinatura TEXT,
      validadeProposta TEXT,
      diasRestantes TEXT,
      equipamentos TEXT,
      pedidoEfetuado INTEGER,
      valorPedido REAL NULL,
      valorRestante REAL NULL,
      valorTotal REAL
      )
  ''';
}
