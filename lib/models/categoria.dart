import 'dart:convert';

Categoria categoriaFromJson(String str) => Categoria.fromJson(json.decode(str));
String categoriaToJson(Categoria data) => json.encode(data.toJson());

class Categoria {
  int idCategoria;
  String nombreCategoria;
  bool esActivo;

  Categoria(
      {required this.idCategoria,
      required this.nombreCategoria,
      required this.esActivo});

  Map<String, dynamic> toMap() {
    return {
      'idCategoria': idCategoria,
      'nombreCategoria': nombreCategoria,
      'esActivo': esActivo
    };
  }

  @override
  String toString() {
    return 'Categoria{idCategoria: $idCategoria, nombreCategoria: $nombreCategoria}';
  }

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
      idCategoria: json["idCategoria"],
      nombreCategoria: json["nombreCategoria"],
      esActivo: json["esActivo"]);

  Map<String, dynamic> toJson() => {
        'idCategoria': idCategoria,
        'nombreCategoria': nombreCategoria,
        'esActivo': esActivo
      };
}
