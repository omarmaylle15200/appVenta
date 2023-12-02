import 'dart:convert';

PerfilUsuario perfilUsuarioFromJson(String str) => PerfilUsuario.fromJson(json.decode(str));
String perfilUsuarioToJson(PerfilUsuario data) => json.encode(data.toJson());

class PerfilUsuario {
  int idPerfilUsuario;
  String nombrePerfilUsuario;
  bool esActivo;

  PerfilUsuario(
      {required this.idPerfilUsuario,
      required this.nombrePerfilUsuario,
      required this.esActivo});

  Map<String, dynamic> toMap() {
    return {
      'idPerfilUsuario': idPerfilUsuario,
      'nombrePerfilUsuario': nombrePerfilUsuario,
      'esActivo': esActivo
    };
  }

  @override
  String toString() {
    return 'PerfilUsuario{idPerfilUsuario: $idPerfilUsuario, nombrePerfilUsuario: $nombrePerfilUsuario}';
  }

  factory PerfilUsuario.fromJson(Map<String, dynamic> json) => PerfilUsuario(
      idPerfilUsuario: json["idPerfilUsuario"],
      nombrePerfilUsuario: json["nombrePerfilUsuario"],
      esActivo: json["esActivo"]);

  Map<String, dynamic> toJson() => {
        'idPerfilUsuario': idPerfilUsuario,
        'nombrePerfilUsuario': nombrePerfilUsuario,
        'esActivo': esActivo
      };
}
