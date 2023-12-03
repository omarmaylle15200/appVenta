import 'dart:convert';
import 'dart:io';

import 'package:appventa/global.dart';
import 'package:appventa/models/usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioService {
  Future<Usuario> iniciarSesion(Usuario usuarioDTO) async {
    Usuario usuario = Usuario(
        idUsuario: 0,
        nombre: '',
        apellidos: '',
        idTipoDocumento: 0,
        idPerfilUsuario: 0,
        numeroDocumento: '',
        direccion: '',
        email: '',
        clave: '',
        esActivo: false);

    try {
      var url = Uri.parse("${uriApiVentas}/Usuario/iniciarSesion");

      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(usuarioDTO));
      if (response.statusCode != 200) {
        return usuario;
      }
      if(response.body==""){
        return usuario;
      }
      
      var decodeData = jsonDecode(response.body) as Map<String, dynamic>;
      usuario = Usuario.fromJson(decodeData);
      // productos=decodeData.map((e) => Producto.fromJson(e)).toList();
    } catch (error) {
      print(error);
    }
    return usuario;
  }
}
