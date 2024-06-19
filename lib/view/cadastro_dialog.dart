import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:nicolas/core/constants.dart';
import 'package:nicolas/core/extensions.dart';
import 'package:nicolas/view_model/get_pregoes.dart';

class CadastroDialog extends StatefulWidget {
  const CadastroDialog({super.key});

  @override
  State<CadastroDialog> createState() => _CadastroDialogState();
}

enum EfetuadoC { sim, nao }

class _CadastroDialogState extends State<CadastroDialog> {
  final TextEditingController _orgaoController = TextEditingController();
  final TextEditingController _numPregaoController = TextEditingController();
  final TextEditingController _initDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String assinado = Constants.instance.assinado.first;
  final TextEditingController _dtAssinaturaController = TextEditingController();
  final TextEditingController _validadePropostaController =
      TextEditingController();
  final TextEditingController _equipamentosController = TextEditingController();
  final TextEditingController _valorTotalController = TextEditingController();

  var maskDate = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> success = ValueNotifier<bool>(false);

  EfetuadoC _efetuado = EfetuadoC.sim;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close)),
              TextFormField(
                controller: _orgaoController,
                decoration: const InputDecoration(labelText: 'Orgão'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Orgão deve ser preenchido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _numPregaoController,
                decoration:
                    const InputDecoration(labelText: "Número do Pregão"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Número do Pregão deve ser preenchido';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _initDateController,
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
                                    _initDateController.text =
                                        value.formatado();
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
                      controller: _endDateController,
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
                                    _endDateController.text = value.formatado();
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
              Column(
                children: [
                  const Text('Já assinado?'),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<EfetuadoC>(
                          title: const Text('Sim'),
                          value: EfetuadoC.sim,
                          groupValue: _efetuado,
                          onChanged: (value) {
                            setState(() {
                              assinado = 'sim';
                              _efetuado = EfetuadoC.sim;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<EfetuadoC>(
                          title: const Text('Não'),
                          value: EfetuadoC.nao,
                          groupValue: _efetuado,
                          onChanged: (value) {
                            setState(() {
                              assinado = 'não';
                              _efetuado = EfetuadoC.nao;
                              _dtAssinaturaController.clear();
                              _validadePropostaController.clear();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dtAssinaturaController,
                      readOnly: assinado == 'não',
                      inputFormatters: [maskDate],
                      decoration: InputDecoration(
                        labelText: "Data da Assinatura",
                        filled: assinado == 'sim' ? true : false,
                        suffixIcon: assinado == 'não'
                            ? null
                            : IconButton(
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
                                          _dtAssinaturaController.text =
                                              value.formatado();
                                        });
                                      }
                                    },
                                  );
                                },
                                icon: const Icon(Icons.calendar_month),
                              ),
                      ),
                      validator: (value) {
                        if ((value == null || value.isEmpty) &&
                            assinado == 'sim') {
                          return 'Data assinatura deve ser preenchido';
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
                      controller: _validadePropostaController,
                      readOnly: assinado == 'não',
                      decoration: InputDecoration(
                        filled: assinado == 'sim' ? true : false,
                        labelText: "Validade da Proposta (meses)",
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      validator: (value) {
                        if ((value == null || value.isEmpty) &&
                            assinado == 'sim') {
                          return 'Validade proposta deve ser preenchido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _equipamentosController,
                decoration: const InputDecoration(labelText: "Equipamentos"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Equipamentos deve ser preenchido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorTotalController,
                decoration: const InputDecoration(
                    labelText: "Valor total do Pregão (R\$)"),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Valor total deve ser preenchido';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        GetPregoesNotifier()
                            .addPregao(
                          orgao: _orgaoController.text,
                          numPregao: _numPregaoController.text,
                          initDate: _initDateController.text,
                          endDate: _endDateController.text,
                          assinado: assinado,
                          efetuado: 'não',
                          dtAssinatura: _dtAssinaturaController.text,
                          validadeProposta: _validadePropostaController.text,
                          equipamentos: _equipamentosController.text,
                          valorTotal: _valorTotalController.text,
                        )
                            .then(
                          (value) {
                            _orgaoController.clear();
                            _numPregaoController.clear();
                            _initDateController.clear();
                            _endDateController.clear();
                            _dtAssinaturaController.clear();
                            _validadePropostaController.clear();
                            _equipamentosController.clear();
                            _valorTotalController.clear();

                            success.value = true;

                            Future.delayed(
                              const Duration(seconds: 3),
                              () {
                                success.value = false;
                              },
                            );
                          },
                        );
                      }
                    },
                    child: const Text('Cadastrar'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ValueListenableBuilder(
                    valueListenable: success,
                    builder: (context, value, child) {
                      return Offstage(
                        offstage: !value,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            Text(
                              'Cadastro efetuado com sucesso',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
