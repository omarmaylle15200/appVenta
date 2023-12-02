import 'dart:convert';
import 'dart:io';

import 'package:appventa/models/categoria.dart';

class CategoriaService {
  List<Categoria> listaCategorias = [];

  Future<List<Categoria>> obtenerCategorias() async {
    listaCategorias = [];
    listaCategorias.add(Categoria(
        idCategoria: 1, nombreCategoria: 'nombreCategoria 1', esActivo: true));
    listaCategorias.add(Categoria(
        idCategoria: 2, nombreCategoria: 'nombreCategoria 2', esActivo: true));
    listaCategorias.add(Categoria(
        idCategoria: 3, nombreCategoria: 'nombreCategoria 3', esActivo: true));
    listaCategorias.add(Categoria(
        idCategoria: 4, nombreCategoria: 'nombreCategoria 4', esActivo: true));
    listaCategorias.add(Categoria(
        idCategoria: 5, nombreCategoria: 'nombreCategoria 5', esActivo: true));
    return listaCategorias;
  }
}
