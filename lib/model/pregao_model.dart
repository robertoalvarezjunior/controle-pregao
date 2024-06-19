import 'dart:convert';

class PregaoModel {
  PregaoModel({
    this.id,
    required this.orgao,
    required this.numPregao,
    required this.dataInicial,
    required this.dataFinal,
    required this.assinado,
    required this.dataAssinatura,
    required this.validadeProposta,
    required this.diasRestantes,
    required this.equipamentos,
    required this.pedidoEfetuado,
    required this.valorTotal,
    this.valorRestante,
    required this.valorPedido,
  });

  final int? id;
  final String orgao;
  final String numPregao;
  final String dataInicial;
  final String dataFinal;
  final int assinado;
  final String dataAssinatura;
  final String validadeProposta;
  final String diasRestantes;
  final String equipamentos;
  final int pedidoEfetuado;
  final double valorTotal;
  final double? valorRestante;
  final double? valorPedido;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'orgao': orgao,
      'numPregao': numPregao,
      'dataInicial': dataInicial,
      'dataFinal': dataFinal,
      'assinado': assinado,
      'dataAssinatura': dataAssinatura,
      'validadeProposta': validadeProposta,
      'diasRestantes': diasRestantes,
      'equipamentos': equipamentos,
      'pedidoEfetuado': pedidoEfetuado,
      'valorTotal': valorTotal,
      'valorRestante': valorRestante,
      'valorPedido': valorPedido,
    };
  }

  factory PregaoModel.fromMap(Map<String, dynamic> map) {
    return PregaoModel(
      id: map['id'] != null ? map['id'] as int : null,
      orgao: map['orgao'] as String,
      numPregao: map['numPregao'] as String,
      dataInicial: map['dataInicial'] as String,
      dataFinal: map['dataFinal'] as String,
      assinado: map['assinado'] as int,
      dataAssinatura: map['dataAssinatura'] as String,
      validadeProposta: map['validadeProposta'] as String,
      diasRestantes: map['diasRestantes'] as String,
      equipamentos: map['equipamentos'] as String,
      pedidoEfetuado: map['pedidoEfetuado'] as int,
      valorTotal: map['valorTotal'] as double,
      valorRestante:
          map['valorRestante'] != null ? map['valorRestante'] as double : null,
      valorPedido:
          map['valorPedido'] != null ? map['valorPedido'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PregaoModel.fromJson(String source) =>
      PregaoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
