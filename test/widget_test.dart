// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  test(
    'body',
    () async {
      // Inicializa os dados de fuso horário
      tz.initializeTimeZones();

      // Exemplo de uso
      String dataAssinaturaStr =
          '18/06/2024'; // Data de assinatura em formato dd/MM/yyyy
      int validadePropostaMeses = 2; // Validade da proposta em meses

      int diasRestantes =
          calcularDiasRestantes(dataAssinaturaStr, validadePropostaMeses);
      log('Dias restantes: ${diasRestantes + 1}');
    },
  );
}

int calcularDiasRestantes(String dataAssinaturaStr, int validadePropostaMeses) {
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

  return diasRestantes;
}
