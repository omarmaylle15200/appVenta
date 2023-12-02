import 'dart:convert';

Pedido pedidoFromJson(String str) => Pedido.fromJson(json.decode(str));
String pedidoToJson(Pedido data) => json.encode(data.toJson());

class Pedido {
  int idPedido;
  int idTipoPedido;
  int idUsuarioRegistro;
  int idUsuarioActualizacion;
  DateTime fechaRegistro;
  DateTime fechaActualizacion;
  bool esActivo;

  Pedido(
      {required this.idPedido,
      required this.idTipoPedido,
      required this.idUsuarioRegistro,
      required this.idUsuarioActualizacion,
      required this.fechaRegistro,
      required this.fechaActualizacion,
      required this.esActivo});

  Map<String, dynamic> toMap() {
    return {
      'idPedido': idPedido,
      'idTipoPedido': idTipoPedido,
      'idUsuarioRegistro': idUsuarioRegistro,
      'idUsuarioActualizacion': idUsuarioActualizacion,
      'fechaRegistro': fechaRegistro,
      'fechaActualizacion': fechaActualizacion,
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
      fechaRegistro: json["fechaRegistro"],
      fechaActualizacion: json["fechaActualizacion"],
      esActivo: json["esActivo"]);

  Map<String, dynamic> toJson() => {
        'idPedido': idPedido,
        'idTipoPedido': idTipoPedido,
        'idUsuarioRegistro': idUsuarioRegistro,
        'idUsuarioActualizacion': idUsuarioActualizacion,
        'fechaRegistro': fechaRegistro,
        'fechaActualizacion': fechaActualizacion,
        'esActivo': esActivo
      };
}
