import 'package:flutter/material.dart';

import 'package:nicolas/database/del_item.dart';
import 'package:nicolas/database/get_db.dart';
import 'package:nicolas/database/insert_db.dart';
import 'package:nicolas/database/update_pregao.dart';
import 'package:nicolas/model/pregao_model.dart';

final class GetPregoesNotifier with ChangeNotifier {
  List<PregaoModel> listaPregoes = [];
  void getPregoes() async {
    var pregao = await GetDb().getPregao();

    listaPregoes = pregao;
    notifyListeners();
  }

  Future<void> addPregao({
    required String orgao,
    required String numPregao,
    required String initDate,
    required String endDate,
    required String assinado,
    required String efetuado,
    String? dtAssinatura,
    required String validadeProposta,
    required String equipamentos,
    required String valorTotal,
  }) async {
    await InsertDb().cadastroPregao(
      orgao: orgao,
      numPregao: numPregao,
      initDate: initDate,
      endDate: endDate,
      assinado: assinado,
      efetuado: efetuado,
      dtAssinatura: dtAssinatura,
      validadeProposta: validadeProposta,
      equipamentos: equipamentos,
      valorTotal: valorTotal,
    );
  }

  Future<void> deletePregao({required int id}) async {
    await DelItem().deleteItem(id: id);
  }

  Future<void> updatePregao({required PregaoModel pregao}) async {
    await UpdatePregao().updatePregao(pregao);
  }
}
