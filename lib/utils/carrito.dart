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
    pedidoDetalle.producto = producto;

    if (items.containsKey(producto.idProducto)) {
      incrementarItem(producto.idProducto);
    } else {
      items.putIfAbsent(producto.idProducto, () => pedidoDetalle);
    }
  }

  void removerItem(int idProducto) {
    items.remove(idProducto);
  }

  void incrementarItem(int idProducto) {
    if (!items.containsKey(idProducto)) return;

    print(items[idProducto]!.idProducto);
    print(items[idProducto]!.cantidad);
    print(items[idProducto]!.precio);

    PedidoDetalle pedidoDetalle = items[idProducto]!;
    if(pedidoDetalle.producto?.stock==pedidoDetalle.cantidad) return;

    pedidoDetalle.cantidad = pedidoDetalle.cantidad! + 1;
    pedidoDetalle.subTotal = pedidoDetalle.cantidad! * pedidoDetalle.precio!;

    items.update(idProducto, (value) => pedidoDetalle);
  }

  void reducirItem(int idProducto) {
    if (!items.containsKey(idProducto)) return;

    if (items[idProducto]!.cantidad! > 1) {
      PedidoDetalle pedidoDetalle = items[idProducto]!;
      pedidoDetalle.cantidad = pedidoDetalle.cantidad! - 1;
      pedidoDetalle.subTotal = pedidoDetalle.cantidad! * pedidoDetalle.precio!;

      items.update(idProducto, (value) => pedidoDetalle);
    } else {
      items.remove(idProducto);
    }
  }

  void removerCarrito() {
    items = {};
  }

  @override
  notifyListeners();
}
