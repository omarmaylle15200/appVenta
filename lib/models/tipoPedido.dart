import 'dart:convert';

TipoPedido tipoPedidoFromJson(String str) => TipoPedido.fromJson(json.decode(str));
String tipoPedidoToJson(TipoPedido data) => json.encode(data.toJson());

class TipoPedido {
  int idTipoPedido;
  String nombreTipoPedido;
  bool esActivo;

  TipoPedido(
      {required this.idTipoPedido,
      required this.nombreTipoPedido,
      required this.esActivo});

  Map<String, dynamic> toMap() {
    return {
      'idTipoPedido': idTipoPedido,
      'nombreTipoPedido': nombreTipoPedido,
      'esActivo': esActivo
    };
  }

  @override
  String toString() {
    return 'TipoPedido{idTipoPedido: $idTipoPedido, nombreTipoPedido: $nombreTipoPedido}';
  }

  factory TipoPedido.fromJson(Map<String, dynamic> json) => TipoPedido(
      idTipoPedido: json["idTipoPedido"],
      nombreTipoPedido: json["nombreTipoPedido"],
      esActivo: json["esActivo"]);

  Map<String, dynamic> toJson() => {
        'idTipoPedido': idTipoPedido,
        'nombreTipoPedido': nombreTipoPedido,
        'esActivo': esActivo
      };
}
