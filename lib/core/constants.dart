class Constants {
  const Constants._();

  static const Constants instance = Constants._();

  List<String> get titleTableVisualizacao => [
        "Órgão",
        "Número do Pregão",
        "Data Início do Pregão",
        "Data Encerramento do Pregão",
        "Data da Assinatura",
        "Validade da Proposta (meses)",
        "Dias Restantes",
        "Equipamentos",
        "Pedido Efetuado",
        "Valor total",
        "Valor Pedido",
        "Valor Restante",
        '',
      ];

  List<String> get assinado => ['sim', 'não'];
  List<String> get pedidoEfetuado => ['sim', 'não'];
}
