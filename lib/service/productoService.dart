import 'dart:convert';
import 'dart:io';

import 'package:appventa/models/producto.dart';

class ProductoService {
  
  static List<Producto> listaProductos=[];

  static Future<bool> registrarProducto(Producto producto) async {
    producto.idProducto=listaProductos.length;
    listaProductos.add(producto);
    return true;
  }

  static Future<List<Producto>> obtenerProductos() async {
    return listaProductos;
  }

  static Future<Producto> obtenerProducto(int idProducto) async {
    Producto producto=listaProductos.where((element) => element.idProducto==idProducto).first;
    return producto;
  }

  static Future<bool> actualizarProducto(Producto producto) async {
    bool found = listaProductos.contains((element) => element.idProducto == producto.idProducto);
    if(!found)return false;

    listaProductos[listaProductos.indexWhere((element) => element.idProducto == producto.idProducto)] = producto;
    return true;
  }

}
