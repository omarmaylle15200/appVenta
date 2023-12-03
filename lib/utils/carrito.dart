import 'package:appventa/models/pedidoDetalle.dart';
import 'package:appventa/models/producto.dart';
import 'package:flutter/material.dart';

class Carrito extends ChangeNotifier {
  Map<int, PedidoDetalle> items = {};

  int numeroItems() {
    return items.length;
  }

  double montoTotal() {
    var total = 0.0;
    items.forEach((key, value) => total += value.subTotal!);

    return total;
  }

  void agregarItem(Producto producto, int cantidad) {
    PedidoDetalle pedidoDetalle = PedidoDetalle.only();
    pedidoDetalle.idProducto = producto.idProducto;
    pedidoDetalle.cantidad = cantidad;
    pedidoDetalle.precio = producto.precio;
    pedidoDetalle.subTotal = producto.precio * cantidad;

    if (items.containsKey(producto.idProducto)) {
      items.update(producto.idProducto, (value) => pedidoDetalle);
    } else {
      items.putIfAbsent(producto.idProducto, () => pedidoDetalle);
    }
  }

  void removerItem(int idProducto) {
    items.remove(idProducto);
  }

  void incrementarItem(int idProducto, int cantidad) {
    if (!items.containsKey(idProducto)) return;

    if (items[idProducto]!.cantidad!>1) {
      PedidoDetalle pedidoDetalle = items[idProducto]!;
      pedidoDetalle.cantidad = cantidad;
      pedidoDetalle.subTotal = cantidad * pedidoDetalle.precio!;

      items.update(idProducto, (value) => pedidoDetalle);
    }else{
      items.remove(idProducto);
    }
  }

  void removerCarrito(){
    items={};
  }
  
  @override
  notifyListeners();
}
