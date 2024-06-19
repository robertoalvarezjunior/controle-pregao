import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:nicolas/core/extensions.dart';
import 'package:nicolas/model/pregao_model.dart';
import 'package:nicolas/view_model/get_pregoes.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({
    super.key,
    required this.data,
  });
  final PregaoModel data;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

enum Efetuado { sim, nao }

class _EditDialogState extends State<EditDialog> {
  @override
  void initState() {
    super.initState();
    efet = widget.data.pedidoEfetuado;
    orgaoController = TextEditingController(text: widget.data.orgao);
    numPregaoController = TextEditingController(text: widget.data.numPregao);
    initDateController = TextEditingController(text: widget.data.dataInicial);
    endDateController = TextEditingController(text: widget.data.dataFinal);
    dtAssinaturaController =
        TextEditingController(text: widget.data.dataAssinatura);
    validadePropostaController =
        TextEditingController(text: widget.data.validadeProposta);
    equipamentosController =
        TextEditingController(text: widget.data.equipamentos);
    valorTotalController = TextEditingController(
        text: widget.data.valorTotal.toStringAsFixed(2).replaceAll('.', ','));
    valorPedidoController = TextEditingController(
        text:
            '${widget.data.valorPedido?.toStringAsFixed(2).replaceAll('.', ',') ?? 0}');
    _efetuado = efet == 1 ? Efetuado.sim : Efetuado.nao;
  }

  var maskDate = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  late Efetuado? _efetuado;

  late final int efet;

  late final TextEditingController orgaoController;

  late final TextEditingController numPregaoController;

  late final TextEditingController initDateController;

  late final TextEditingController endDateController;

  late final TextEditingController dtAssinaturaController;

  late final TextEditingController validadePropostaController;

  late final TextEditingController equipamentosController;

  late final TextEditingController valorTotalController;
  late final TextEditingController valorPedidoController;
  @override
  Widget build(BuildContext context) {
    const SizedBox space = SizedBox(height: 10);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close)),
              space,
              TextFormField(
                controller: orgaoController,
                decoration: const InputDecoration(labelText: 'Orgão'),
              ),
              space,
              TextFormField(
                controller: numPregaoController,
                decoration:
                    const InputDecoration(labelText: 'Número do Pregão'),
              ),
              space,
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: initDateController,
                      inputFormatters: [maskDate],
                      decoration: InputDecoration(
                        labelText: "Data Início do Pregão",
                        suffixIcon: IconButton(
                          onPressed: () async {
                            await showDatePicker(
                              locale: const Locale('pt', 'BR'),
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            ).then(
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    initDateController.text = value.formatado();
                                  });
                                }
                              },
                            );
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Data Início deve ser preenchido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: endDateController,
                      inputFormatters: [maskDate],
                      decoration: InputDecoration(
                        labelText: "Data Encerramento do Pregão",
                        suffixIcon: IconButton(
                          onPressed: () async {
                            await showDatePicker(
                              locale: const Locale('pt', 'BR'),
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            ).then(
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    endDateController.text = value.formatado();
                                  });
                                }
                              },
                            );
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Data final deve ser preenchido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              space,
              Column(
                children: [
                  const Text('Pedido Efetuado?'),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<Efetuado>(
                          title: const Text('Sim'),
                          value: Efetuado.sim,
                          groupValue: _efetuado,
                          onChanged: (value) {
                            setState(() {
                              _efetuado = Efetuado.sim;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<Efetuado>(
                          title: const Text('Não'),
                          value: Efetuado.nao,
                          groupValue: _efetuado,
                          onChanged: (value) {
                            setState(() {
                              _efetuado = Efetuado.nao;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              space,
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: dtAssinaturaController,
                      decoration: InputDecoration(
                        labelText: 'Data de Assinatura',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            await showDatePicker(
                              locale: const Locale('pt', 'BR'),
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            ).then(
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    dtAssinaturaController.text =
                                        value.formatado();
                                  });
                                }
                              },
                            );
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      controller: validadePropostaController,
                      decoration: const InputDecoration(
                          labelText: 'Validade da Proposta'),
                    ),
                  ),
                ],
              ),
              space,
              TextFormField(
                controller: equipamentosController,
                decoration: const InputDecoration(labelText: 'Equipamentos'),
              ),
              space,
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: valorTotalController,
                      decoration:
                          const InputDecoration(labelText: 'Valor Total'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      controller: valorPedidoController,
                      decoration:
                          const InputDecoration(labelText: 'Valor Pedido'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                    ),
                  ),
                ],
              ),
              space,
              FilledButton(
                onPressed: () {
                  GetPregoesNotifier()
                      .updatePregao(
                    pregao: PregaoModel(
                      id: widget.data.id,
                      orgao: orgaoController.text,
                      numPregao: numPregaoController.text,
                      dataInicial: initDateController.text,
                      dataFinal: endDateController.text,
                      assinado: widget.data.assinado,
                      dataAssinatura: dtAssinaturaController.text,
                      validadeProposta: validadePropostaController.text,
                      diasRestantes: widget.data.diasRestantes,
                      equipamentos: equipamentosController.text,
                      pedidoEfetuado: _efetuado == Efetuado.sim ? 1 : 0,
                      valorTotal: double.parse(
                          valorTotalController.text.replaceAll(',', '.')),
                      valorPedido: double.parse(
                        valorPedidoController.text.replaceAll(',', '.'),
                      ),
                    ),
                  )
                      .then(
                    (value) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pregão atualizado com sucesso!'),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Atualizar'),
              ),
              space,
            ],
          ),
        ),
      ),
    );
  }
}
