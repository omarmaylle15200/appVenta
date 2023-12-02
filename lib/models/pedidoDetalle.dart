import 'dart:convert';

PedidoDetalle pedidoDetalleFromJson(String str) =>
    PedidoDetalle.fromJson(json.decode(str));
String pedidoDetalleToJson(PedidoDetalle data) => json.encode(data.toJson());

class PedidoDetalle {
  int idPedido;
  int idPedidoDetalle;
  int idProducto;
  double precio;
  int cantidad;
  double subTotal;

  PedidoDetalle(
      {required this.idPedido,
      required this.idPedidoDetalle,
      required this.idProducto,
      required this.precio,
      required this.cantidad,
      required this.subTotal});

  Map<String, dynamic> toMap() {
    return {
      'idPedido': idPedido,
      'idPedidoDetalle': idPedidoDetalle,
      'idProducto': idProducto,
      'precio': precio,
      'cantidad': cantidad,
      'subTotal': subTotal
    };
  }

  @override
  String toString() {
    return 'PedidoDetalle{idPedido: $idPedido, idPedidoDetalle: $idPedidoDetalle}';
  }

  factory PedidoDetalle.fromJson(Map<String, dynamic> json) => PedidoDetalle(
      idPedido: json["idPedido"],
      idPedidoDetalle: json["idPedidoDetalle"],
      idProducto: json["idProducto"],
      precio: json["precio"],
      cantidad: json["cantidad"],
      subTotal: json["subTotal"]);

  Map<String, dynamic> toJson() => {
        'idPedido': idPedido,
        'idPedidoDetalle': idPedidoDetalle,
        'idProducto': idProducto,
        'precio': precio,
        'cantidad': cantidad,
        'subTotal': subTotal
      };
}
