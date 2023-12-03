import 'dart:convert';
import 'dart:io';

import 'package:appventa/global.dart';
import 'package:appventa/models/producto.dart';
import 'package:http/http.dart' as http;

class ProductoService {
  List<Producto> listaProductos = [];

  Future<List<Producto>> obtenerProductos(int idCategoria) async {
    List<Producto> productos = [];

    try {
      var url = Uri.parse(
          "${uriApiVentas}/Producto/obtenerProductos?idCategoria=${idCategoria}");

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return listaProductos;
      }
      var decodeData = jsonDecode(response.body) as List;
      decodeData.forEach((element) {
        final producto = Producto.fromJson(element);
        productos.add(producto);
      });
      // productos=decodeData.map((e) => Producto.fromJson(e)).toList();
    } catch (error) {
      print(error);
    }

    return productos;
  }

  Future<Producto> obtenerProducto(int idProducto) async {
    Producto producto = Producto(
        idProducto: 0,
        nombreProducto: '',
        precio: 0,
        stock: 0,
        idCategoria: 0,
        esActivo: false);

    try {
      var url = Uri.parse(
          "${uriApiVentas}/Producto/obtenerProductoPorId?idProducto=${idProducto}");

      final response = await http.get(url);
      if (response.statusCode != 200) {
        return producto;
      }
      if (response.body == "") {
        return producto;
      }

      var decodeData = jsonDecode(response.body) as Map<String, dynamic>;
      producto = Producto.fromJson(decodeData);
      // productos=decodeData.map((e) => Producto.fromJson(e)).toList();
    } catch (error) {
      print(error);
    }

    return producto;
  }

  Future<bool> registrarProducto(Producto producto) async {
    bool resp = false;
    try {
      var url = Uri.parse("${uriApiVentas}/Producto/registrar");

      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(producto));
      if (response.statusCode != 200) {
        return resp;
      }

      var r = jsonDecode(response.body) as int;
      resp = r == 1 ? true : false;
    } catch (error) {
      print(error);
    }
    return resp;
  }

  Future<bool> actualizarProducto(Producto producto) async {
    bool resp = false;
    try {
      var url = Uri.parse("${uriApiVentas}/Producto/actualizar");

      final response = await http.put(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(producto));
      if (response.statusCode != 200) {
        return resp;
      }

      var r = jsonDecode(response.body) as int;
      resp = r == 1 ? true : false;
    } catch (error) {
      print(error);
    }
    return resp;
  }
}
