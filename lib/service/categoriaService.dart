import 'dart:convert';
import 'dart:io';

import 'package:appventa/global.dart';
import 'package:appventa/models/categoria.dart';
import 'package:http/http.dart' as http;

class CategoriaService {
  Future<List<Categoria>> obtenerCategorias() async {
    List<Categoria> categorias = [];
    try {
      var url = Uri.parse("${uriApiVentas}/Categoria/obtenerCategorias");

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return categorias;
      }
      var decodeData = jsonDecode(response.body) as List;
      decodeData.forEach((element) {
        final categoria = Categoria.fromJson(element);
        categorias.add(categoria);
      });
      // productos=decodeData.map((e) => Producto.fromJson(e)).toList();
    } catch (error) {
      print(error);
    }
    return categorias;
  }
}
