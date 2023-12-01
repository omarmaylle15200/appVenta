import 'dart:convert';
import 'dart:io';

import 'package:appventa/models/usuario.dart';

class UsuarioService {
  static Future<Usuario> iniciarSesion(Usuario usuario1) async {
    Usuario usuario =  Usuario(
        idUsuario: 1,
        nombre: '',
        apellidos: '',
        idTipoDocumento: 1,
        idPerfilUsuario: 1,
        numeroDocumento: usuario1.numeroDocumento,
        direccion: '',
        email: '',
        clave: '',
        esActivo: true);
    return usuario;
  }
}
