import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:nicolas/database/local_database.dart';

final class InsertDb {
  InsertDb();

  late Database db;

  Future<void> cadastroPregao({
    required String orgao,
    required String numPregao,
    required String initDate,
    required String endDate,
    required String assinado,
    required String efetuado,
    String? dtAssinatura,
    String? validadeProposta,
    required String equipamentos,
    required String valorTotal,
  }) async {
    db = await LocalDatabase.instance.database;

    int diasRestantes = 0;

    if ((dtAssinatura != null && dtAssinatura.isNotEmpty) &&
        (validadeProposta != null && validadeProposta.isNotEmpty)) {
      // Inicializa os dados de fuso horário
      tz.initializeTimeZones();

      // Exemplo de uso
      String dataAssinaturaStr =
          dtAssinatura; // Data de assinatura em formato dd/MM/yyyy
      int validadePropostaMeses =
          int.parse(validadeProposta); // Validade da proposta em meses

      int dr = _calcularDiasRestantes(dataAssinaturaStr, validadePropostaMeses);

      diasRestantes = dr;
    }

    int assis = assinado == 'sim' ? 1 : 0;
    int efet = efetuado == 'sim' ? 1 : 0;

    double valTotal = double.parse(valorTotal.replaceAll(',', '.'));

    await db.transaction(
      (txn) async {
        await txn.rawInsert(
          'INSERT INTO Pregao (id, orgao, numPregao, dataInicial, dataFinal, assinado, dataAssinatura, validadeProposta, diasRestantes, equipamentos, pedidoEfetuado, valorPedido, valorRestante, valorTotal) VALUES (null, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, null, null, ?)',
          [
            orgao,
            numPregao,
            initDate,
            endDate,
            assis,
            dtAssinatura ?? '',
            validadeProposta ?? '',
            diasRestantes,
            equipamentos,
            efet,
            valTotal,
          ],
        );
      },
    );
  }
}

int _calcularDiasRestantes(
    String dataAssinaturaStr, int validadePropostaMeses) {
  final formato = DateFormat('dd/MM/yyyy');
  final dataAssinatura = formato.parse(dataAssinaturaStr);

  // Converte a data de assinatura para o fuso horário local
  final dataAssinaturaTz = tz.TZDateTime.from(dataAssinatura, tz.local);

  // Adiciona meses à data de assinatura
  final dataValidade = tz.TZDateTime(
    tz.local,
    dataAssinaturaTz.year,
    dataAssinaturaTz.month + validadePropostaMeses,
    dataAssinaturaTz.day,
  );

  // Obtém a data atual no fuso horário local
  final dataAtual = tz.TZDateTime.now(tz.local);

  // Calcula a diferença em dias entre a data de validade e a data atual
  final diasRestantes = dataValidade.difference(dataAtual).inDays;

  return diasRestantes + 1;
}
