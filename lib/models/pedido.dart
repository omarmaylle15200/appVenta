import 'dart:convert';

import 'package:appventa/models/pedidoDetalle.dart';

Pedido pedidoFromJson(String str) => Pedido.fromJson(json.decode(str));
String pedidoToJson(Pedido data) => json.encode(data.toJson());

class Pedido {
  int? idPedido;
  int? idTipoPedido;
  int? idUsuarioRegistro;
  int? idUsuarioActualizacion;
  DateTime? fechaRegistro;
  DateTime? fechaActualizacion;
  bool? esActivo;
  double? total;
  List<PedidoDetalle>? pedidoDetalles;

  Pedido.only();

  Pedido(
      {required this.idPedido,
      required this.idTipoPedido,
      required this.idUsuarioRegistro,
      required this.idUsuarioActualizacion,
      required this.fechaRegistro,
      required this.fechaActualizacion,
      required this.total,
      required this.esActivo});

  Map<String, dynamic> toMap() {
    return {
      'idPedido': idPedido,
      'idTipoPedido': idTipoPedido,
      'idUsuarioRegistro': idUsuarioRegistro,
      'idUsuarioActualizacion': idUsuarioActualizacion,
      'fechaRegistro': fechaRegistro,
      'fechaActualizacion': fechaActualizacion,
      'total': total,
      'pedidoDetalles': pedidoDetalles,
      'esActivo': esActivo
    };
  }

  @override
  String toString() {
    return 'Pedido{idPedido: $idPedido, idTipoPedido: $idTipoPedido}';
  }

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
      idPedido: json["idPedido"],
      idTipoPedido: json["idTipoPedido"],
      idUsuarioRegistro: json["idUsuarioRegistro"],
      idUsuarioActualizacion: json["idUsuarioActualizacion"],
      fechaRegistro: DateTime.tryParse(json["fechaRegistro"]),
      fechaActualizacion: DateTime.tryParse(json["fechaActualizacion"]),
      total: json["total"],
      esActivo: json["esActivo"]);

  Map<String, dynamic> toJson() => {
        'idPedido': idPedido,
        'idTipoPedido': idTipoPedido,
        'idUsuarioRegistro': idUsuarioRegistro,
        'idUsuarioActualizacion': idUsuarioActualizacion,
        'fechaRegistro': fechaRegistro,
        'fechaActualizacion': fechaActualizacion,
        'total': total,
        'pedidoDetalles': pedidoDetalles,
        'esActivo': esActivo
      };
}
