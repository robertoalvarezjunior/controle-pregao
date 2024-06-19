// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:material_table_view/table_column_control_handles_popup_route.dart';

import 'package:nicolas/core/constants.dart';
import 'package:nicolas/view/edit_dialog.dart';
import 'package:nicolas/view_model/get_pregoes.dart';

class TableVisualizacaoView extends StatefulWidget {
  const TableVisualizacaoView({
    super.key,
    required this.listaPregoes,
    required this.search,
  });

  final GetPregoesNotifier listaPregoes;
  final String search;

  @override
  State<TableVisualizacaoView> createState() => _TableVisualizacaoViewState();
}

class _TableVisualizacaoViewState extends State<TableVisualizacaoView> {
  @override
  Widget build(BuildContext context) {
    final tb = widget.listaPregoes.listaPregoes
        .where((element) =>
            element.orgao.toLowerCase().contains(widget.search.toLowerCase()) ||
            element.numPregao
                .toLowerCase()
                .contains(widget.search.toLowerCase()))
        .toList();

    return Expanded(
      child: TableView.builder(
        key: const Key('key'),
        columns: columns,
        rowCount: tb.length,
        rowHeight: 56.0,
        headerBuilder: (context, contentBuilder) {
          return contentBuilder(
            context,
            (context, column) => InkWell(
              onTap: () => Navigator.of(context)
                  .push(_createColumnControlsRoute(context, column)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: AutoSizeText(
                    Constants.instance.titleTableVisualizacao[column],
                    maxLines: 2,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ), // build a header widget
          );
        },
        style: const TableViewStyle(
          dividers: TableViewDividersStyle(
            vertical: TableViewVerticalDividersStyle(
              leading: TableViewVerticalDividerStyle(
                  wigglesPerRow: 0, wiggleOffset: 0),
              trailing: TableViewVerticalDividerStyle(
                  wigglesPerRow: 0, wiggleOffset: 0),
            ),
          ),
        ),
        rowBuilder: (context, row, contentBuilder) {
          final data = tb[row];

          return contentBuilder(
            context,
            (context, column) {
              final value = [
                data.orgao,
                data.numPregao,
                data.dataInicial,
                data.dataFinal,
                data.dataAssinatura,
                data.validadeProposta,
                data.diasRestantes,
                data.equipamentos,
                data.pedidoEfetuado == 1 ? 'Sim' : 'Não',
                'R\$ ${data.valorTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                'R\$ ${data.valorPedido?.toStringAsFixed(2).replaceAll('.', ',')}',
                "R\$ ${data.valorRestante?.toStringAsFixed(2).replaceAll('.', ',')}",
                'null',
              ];

              if (value[column] == 'null') {
                return Container(
                  color: row.isEven
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.primaryContainer,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EditDialog(
                                data: data,
                              );
                            },
                          ).then(
                            (value) => widget.listaPregoes.getPregoes(),
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 20, 15, 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AutoSizeText(
                                          'Excluir pregão ${data.orgao} permanentemente?',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                GetPregoesNotifier()
                                                    .deletePregao(id: data.id!);

                                                Navigator.pop(context);
                                              },
                                              child: const Text('Sim'),
                                            ),
                                            const SizedBox(width: 10),
                                            FilledButton.tonal(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Não'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).then(
                            (value) => widget.listaPregoes.getPregoes(),
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                color: row.isEven
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.primaryContainer,
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: AutoSizeText(
                    key: Key('$column-$row'),
                    value[column],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  final columns = <_MyTableColumn>[
    _MyTableColumn(
      index: 0,
      width: 150,
      freezePriority: 150,
    ),
    for (var i = 1; i < Constants.instance.titleTableVisualizacao.length; i++)
      _MyTableColumn(
          index: i,
          width: i == Constants.instance.titleTableVisualizacao.length - 1
              ? 150
              : 150,
          freezePriority:
              i == Constants.instance.titleTableVisualizacao.length - 1
                  ? 150
                  : 0),
  ];

  ModalRoute<void> _createColumnControlsRoute(
    BuildContext cellBuildContext,
    int columnIndex,
  ) =>
      TableColumnControlHandlesPopupRoute.realtime(
        controlCellBuildContext: cellBuildContext,
        columnIndex: columnIndex,
        tableViewChanged: null,
        onColumnTranslate: (index, newTranslation) => setState(
          () => columns[index] =
              columns[index].copyWith(translation: newTranslation),
        ),
        onColumnResize: (index, newWidth) => setState(
          () => columns[index] = columns[index].copyWith(width: newWidth),
        ),
        onColumnMove: (oldIndex, newIndex) => setState(
          () => columns.insert(newIndex, columns.removeAt(oldIndex)),
        ),
        leadingImmovableColumnCount: 1,
        trailingImmovableColumnCount: 1,
        popupBuilder: (context, animation, secondaryAnimation, columnWidth) =>
            PreferredSize(
          preferredSize: Size(min(256, max(192, columnWidth)), 90),
          child: FadeTransition(
            opacity: animation,
            child: Material(
              type: MaterialType.card,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                side: Divider.createBorderSide(context),
                borderRadius: const BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Button to cancel the controls',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _MyTableColumn extends TableColumn {
  _MyTableColumn({
    required int index,
    required super.width,
    super.freezePriority = 0,
    super.sticky = false,
    super.flex = 0,
    super.translation = 0,
    super.minResizeWidth,
    super.maxResizeWidth,
  })  : key = ValueKey<int>(index),
        // ignore: prefer_initializing_formals
        index = index;

  final int index;

  @override
  final ValueKey<int> key;

  @override
  _MyTableColumn copyWith({
    double? width,
    int? freezePriority,
    bool? sticky,
    int? flex,
    double? translation,
    double? minResizeWidth,
    double? maxResizeWidth,
  }) =>
      _MyTableColumn(
        index: index,
        width: width ?? this.width,
        freezePriority: freezePriority ?? this.freezePriority,
        sticky: sticky ?? this.sticky,
        flex: flex ?? this.flex,
        translation: translation ?? this.translation,
        minResizeWidth: minResizeWidth ?? this.minResizeWidth,
        maxResizeWidth: maxResizeWidth ?? this.maxResizeWidth,
      );
}
