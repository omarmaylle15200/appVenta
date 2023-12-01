import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));
String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  int? idUsuario;
  String? nombre;
  String? apellidos;
  int? idTipoDocumento;
  int? idPerfilUsuario;
  String? numeroDocumento;
  String? direccion;
  String? email;
  String? clave;
  bool? esActivo;

 Usuario.onlyLogin({
       this.numeroDocumento,
       this.clave});

  Usuario(
      {required this.idUsuario,
      required this.nombre,
      required this.apellidos,
      required this.idTipoDocumento,
      required this.idPerfilUsuario,
      required this.numeroDocumento,
      required this.direccion,
      required this.email,
      required this.clave,
      required this.esActivo});

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'nombre': nombre,
      'apellidos': apellidos,
      'idTipoDocumento': idTipoDocumento,
      'idPerfilUsuario': idPerfilUsuario,
      'numeroDocumento': numeroDocumento,
      'direccion': direccion,
      'email': email,
      'clave': clave,
      'esActivo': esActivo
    };
  }

  @override
  String toString() {
    return 'Usuario{idUsuario: $idUsuario, nombreUsuario: $nombre}';
  }

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
      idUsuario: json["idUsuario"],
      nombre: json["nombre"],
      apellidos: json["apellidos"],
      idTipoDocumento: json["idTipoDocumento"],
      idPerfilUsuario: json["idPerfilUsuario"],
      numeroDocumento: json["numeroDocumento"],
      direccion: json["direccion"],
      email: json["email"],
      clave: json["clave"],
      esActivo: json["esActivo"]);

  Map<String, dynamic> toJson() => {
        'idUsuario': idUsuario,
        'nombre': nombre,
        'apellidos': apellidos,
        'idTipoDocumento': idTipoDocumento,
        'idPerfilUsuario': idPerfilUsuario,
        'numeroDocumento': numeroDocumento,
        'direccion': direccion,
        'email': email,
        'clave': clave,
        'esActivo': esActivo
      };
}
