import 'dart:convert';
import 'dart:io';

import 'package:appventa/global.dart';
import 'package:appventa/models/pedido.dart';
import 'package:http/http.dart' as http;

class PedidoService {
  List<Pedido> listaPedidos = [];

  Future<bool> registrarPedido(Pedido pedido) async {
    bool resp = false;
    try {
      var url = Uri.parse("${uriApiVentas}/Pedido/registrar");

      var jsonPedido=jsonEncode(pedido);
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonPedido);

      if (response.statusCode != 200) {
        return resp;
      }

      resp = jsonDecode(response.body) as bool;
      
    } catch (error) {
      print(error);
    }
    return resp;
  }

  Future<List<Pedido>> obtenerPedidos(int idTipoPedido,String fechaInicio,String fechaFinal) async {
    List<Pedido> pedidos = [];

    try {
      var url = Uri.parse(
          "${uriApiVentas}/Pedido/obtenerPedidos?idTipoPedido=${idTipoPedido}&fechaInicio=${fechaInicio}&fechaFin=${fechaFinal}");

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return pedidos;
      }
      var decodeData = jsonDecode(response.body) as List;
      decodeData.forEach((element) {
        final producto = Pedido.fromJson(element);
        pedidos.add(producto);
      });
      // productos=decodeData.map((e) => Producto.fromJson(e)).toList();
    } catch (error) {
      print(error);
    }

    return pedidos;
  }

  Future<Pedido> obtenerPedido(int idPedido) async {
    Pedido pedido = Pedido.only();

    try {
      var url = Uri.parse(
          "${uriApiVentas}/Pedido/obtenerPedido?idPedido=${idPedido}");

      final response = await http.get(url);
      if (response.statusCode != 200) {
        return pedido;
      }
      if (response.body == "") {
        return pedido;
      }

      var decodeData = jsonDecode(response.body) as Map<String, dynamic>;
      pedido = Pedido.fromJson(decodeData);
      // productos=decodeData.map((e) => Producto.fromJson(e)).toList();
    } catch (error) {
      print(error);
    }

    return pedido;
  }
}
