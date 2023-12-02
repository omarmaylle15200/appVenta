import 'dart:convert';
import 'dart:io';

import 'package:appventa/global.dart';
import 'package:appventa/models/producto.dart';
import 'package:http/http.dart' as http;

class ProductoService {
  List<Producto> listaProductos = [];

  Future<bool> registrarProducto(Producto producto) async {
    producto.idProducto = listaProductos.length;
    listaProductos.add(producto);
    print(listaProductos);
    return true;
  }

  Future<List<Producto>> obtenerProductos(int idCategoria) async {
   

    List<Producto> productos=[];

    try {
      var url = Uri.parse("${uriApiVentas}/Producto/obtenerProductos?idCategoria=${idCategoria}");

      final response =
          await http.get(url);

      if(response.statusCode!=200){
        return listaProductos;
      }
      var decodeData= jsonDecode(response.body) as List;
      decodeData.forEach((element) {
        final producto=Producto.fromJson(element);
        productos.add(producto);
      });
      // productos=decodeData.map((e) => Producto.fromJson(e)).toList();

    } catch(error){
      print(error);
    }

    return productos;
  }

  Future<Producto> obtenerProducto(int idProducto) async {
    Producto producto = listaProductos
        .where((element) => element.idProducto == idProducto)
        .first;
    return producto;
  }

  Future<bool> actualizarProducto(Producto producto) async {
    bool found = listaProductos
        .contains((element) => element.idProducto == producto.idProducto);
    if (!found) return false;

    listaProductos[listaProductos.indexWhere(
        (element) => element.idProducto == producto.idProducto)] = producto;
    return true;
  }
}
