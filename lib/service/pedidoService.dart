import 'dart:convert';
import 'dart:io';

import 'package:appventa/models/Pedido.dart';

class PedidoService {
  List<Pedido> listaPedidos = [];

  Future<bool> registrarPedido(Pedido pedido) async {
    pedido.idPedido = listaPedidos.length;
    listaPedidos.add(pedido);
    print(listaPedidos);
    return true;
  }

  Future<List<Pedido>> obtenerPedidos() async {
    return listaPedidos;
  }

  Future<Pedido> obtenerPedido(int idPedido) async {
    Pedido pedido = listaPedidos
        .where((element) => element.idPedido == idPedido)
        .first;
    return pedido;
  }

  Future<bool> actualizarPedido(Pedido pedido) async {
    bool found = listaPedidos
        .contains((element) => element.idPedido == pedido.idPedido);
    if (!found) return false;

    listaPedidos[listaPedidos.indexWhere(
        (element) => element.idPedido == pedido.idPedido)] = pedido;
    return true;
  }
}
