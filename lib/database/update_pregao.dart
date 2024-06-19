import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:nicolas/database/local_database.dart';
import 'package:nicolas/model/pregao_model.dart';

final class UpdatePregao {
  UpdatePregao();

  late Database db;

  Future<void> updatePregao(PregaoModel pregao) async {
    db = await LocalDatabase.instance.database;

    final double calcValorRestante = pregao.valorPedido != null
        ? pregao.valorTotal - pregao.valorPedido!
        : pregao.valorTotal;

    int diasRestantes = 0;

    if ((pregao.dataAssinatura.isNotEmpty) &&
        (pregao.validadeProposta.isNotEmpty)) {
      // Inicializa os dados de fuso horário
      tz.initializeTimeZones();

      // Exemplo de uso
      String dataAssinaturaStr =
          pregao.dataAssinatura; // Data de assinatura em formato dd/MM/yyyy
      int validadePropostaMeses =
          int.parse(pregao.validadeProposta); // Validade da proposta em meses

      int dr = _calcularDiasRestantes(dataAssinaturaStr, validadePropostaMeses);

      diasRestantes = dr;
    }

    await db.transaction(
      (txn) async {
        await txn.rawUpdate(
          'UPDATE Pregao SET orgao = ?, numPregao = ?, dataInicial = ?, dataFinal = ?, assinado = ?, dataAssinatura = ?, validadeProposta = ?, diasRestantes = ?, equipamentos = ?, pedidoEfetuado = ?, valorPedido = ?, valorRestante = ?, valorTotal = ? WHERE id = ?',
          [
            pregao.orgao,
            pregao.numPregao,
            pregao.dataInicial,
            pregao.dataFinal,
            pregao.assinado,
            pregao.dataAssinatura,
            pregao.validadeProposta,
            diasRestantes,
            pregao.equipamentos,
            pregao.pedidoEfetuado,
            pregao.valorPedido,
            calcValorRestante.abs(),
            pregao.valorTotal,
            pregao.id,
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
