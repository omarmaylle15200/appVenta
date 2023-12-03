import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));
String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
  int idProducto;
  String nombreProducto;
  double precio;
  int stock;
  int idCategoria;
  bool esActivo;
  int? idUsuarioRegistro;
  int? idUsuarioActualizacion;

  Producto(
      {required this.idProducto,
      required this.nombreProducto,
      required this.precio,
      required this.stock,
      required this.idCategoria,
      required this.esActivo});

  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'nombreProducto': nombreProducto,
      'precio': precio,
      'stock': stock,
      'idCategoria': idCategoria,
      'esActivo': esActivo
    };
  }

  @override
  String toString() {
    return 'Producto{idProducto: $idProducto, nombreProducto: $nombreProducto, precio: $precio}';
  }

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
      idProducto: json["idProducto"],
      nombreProducto: json["nombreProducto"],
      precio: json["precio"],
      stock: json["stock"],
      idCategoria: json["idCategoria"],
      esActivo: json["esActivo"]);

  Map<String, dynamic> toJson() => {
        'idProducto': idProducto,
        'nombreProducto': nombreProducto,
        'precio': precio,
        'stock': stock,
        'idCategoria': idCategoria,
        'esActivo': esActivo
      };
}
