import 'package:appventa/global.dart';
import 'package:appventa/models/pedido.dart';
import 'package:appventa/models/pedidoDetalle.dart';
import 'package:appventa/models/producto.dart';
import 'package:appventa/service/pedidoService.dart';
import 'package:appventa/utils/carrito.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class VentaNuevoDetallePage extends StatefulWidget {
  const VentaNuevoDetallePage({super.key, required this.title});

  final String title;

  @override
  State<VentaNuevoDetallePage> createState() => _VentaNuevoDetallePageState();
}

class _VentaNuevoDetallePageState extends State<VentaNuevoDetallePage> {

  PedidoService pedidoService=PedidoService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Carrito>(builder: (context, carrito, child) {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title)),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: SingleChildScrollView(
                child: Container(
                  child: carrito.numeroItems() == 0
                      ? Center(
                          child: Text("Carrito vacio"),
                        )
                      : Column(
                          children: <Widget>[
                            for (var item in carrito.items.values)
                              _crearItem(context, carrito, item),
                          ],
                        ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "SubTotal: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  Text(
                    "S/ ${NumberFormat("#,##0.00", "en_US").format(carrito.montoTotal())}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool confirmacion = await _crearAlertConfirmacion();
            if (!confirmacion) return;

            bool resp = false;

            Iterable<PedidoDetalle> pedidoDetalles=carrito.items.values;
            Pedido pedido=Pedido.only();
            pedido.pedidoDetalles=pedidoDetalles;
            pedido.idTipoPedido=1;
            pedido.idUsuarioRegistro=usuarioSesion.idUsuario;
            pedido.idUsuarioActualizacion=usuarioSesion.idUsuario;

            //resp=await pedidoService.registrarPedido(pedido);
            print(pedido.pedidoDetalles);
            resp=true;
            if (!resp) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No se pudo registrar')),
              );
              return;
            }

            carrito.removerCarrito();
            Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);

          },
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.send,
            color: Colors.amberAccent,
          ),
        ),
      );
    });
  }

  _crearItem(BuildContext context, Carrito carrito, PedidoDetalle producto) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(color: Colors.blueAccent),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x000005cc),
                  blurRadius: 20,
                  offset: Offset(10, 10))
            ]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  const SizedBox(
                    width: 50,
                    child: Icon(
                      Icons.gif_box_sharp,
                      size: 50,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              textAlign: TextAlign.center,
                              producto.producto!.nombreProducto.toString(),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              textAlign: TextAlign.center,
                              "S/ ${producto.precio}  x   ${producto.cantidad}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 50,
                                ),
                                Expanded(
                                  child: Center(
                                    child: TextButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.amber.shade500)),
                                      onPressed: () => _incrementarItemCarrito(
                                          producto.idProducto!, carrito),
                                      child: const Icon(
                                        Icons.add,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: TextButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.amber.shade500)),
                                      onPressed: () => _reducirItemCarrito(
                                          producto.idProducto!, carrito),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      "S/ ${NumberFormat("#,##0.00", "en_US").format(producto.subTotal)}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }

  _incrementarItemCarrito(int idProducto, Carrito carrito) {
    setState(() {
      carrito.incrementarItem(idProducto);
      carrito.notifyListeners();
    });
  }

  _reducirItemCarrito(int idProducto, Carrito carrito) {
    setState(() {
      carrito.reducirItem(idProducto);
      carrito.notifyListeners();
    });
  }

  Future<bool> _crearAlertConfirmacion() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Venta"),
          content: const Text("Se registrara  venta"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Confirmar")),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }
}
