import 'dart:html';

import 'package:appventa/models/pedidoDetalle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appventa/models/pedido.dart';
import 'package:appventa/service/pedidoService.dart';
import 'package:intl/intl.dart';

GlobalKey<ListaPedidoState> globalKeyListaPedidoState = GlobalKey();

class VentaPage extends StatefulWidget {
  const VentaPage({super.key, required this.title});

  final String title;

  @override
  State<VentaPage> createState() => _VentaPageState();
}

class _VentaPageState extends State<VentaPage> {
  @override
  Widget build(BuildContext context) {
    return _crearAppBar("Ventas");
  }

  _crearAppBar(String titulo) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: ListaPedido(key: globalKeyListaPedidoState),
    );
  }
}

// Create a List widget.
class ListaPedido extends StatefulWidget {
  const ListaPedido({super.key});

  @override
  ListaPedidoState createState() {
    return ListaPedidoState();
  }
}

class ListaPedidoState extends State<ListaPedido> {
  final pedidoService = PedidoService();
  late Future<List<Pedido>> futurePedidos;
  final f = DateFormat('yyyy-MM-dd');
  DateTime fechaInicio = DateTime.now();
  DateTime fechaFinal = DateTime.now();

  @override
  void initState() {
    super.initState();
    _obtenerPedidos(1, f.format(fechaInicio), f.format(fechaFinal));
  }

  @override
  Widget build(BuildContext context) {
    return _crearListado();
  }

  _obtenerPedidos(int idTipoPedido, String fechaInicio, String fechaFinal) {
    setState(() {
      futurePedidos =
          pedidoService.obtenerPedidos(idTipoPedido, fechaInicio, fechaFinal);
    });
  }

  _crearListado() {
    return FutureBuilder(
      future: futurePedidos,
      builder: (BuildContext context, AsyncSnapshot<List<Pedido>> snapshot) {
        // WHILE THE CALL IS BEING MADE AKA LOADING
        if (!snapshot.hasData) {
          return Center(child: Text('Loading'));
        }

        // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
        if (snapshot.hasError) {
          return Center(child: Text("Error"));
        }

        final pedidos = snapshot.data;
        print(pedidos);
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.shade300)),
                      onPressed: () async {
                        DateTime? newFechaInicio = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            initialDate: fechaInicio);
                        if (newFechaInicio == null) return;

                        setState(() {
                          fechaInicio = newFechaInicio;
                          _obtenerPedidos(
                              1, f.format(fechaInicio), f.format(fechaFinal));
                        });
                      },
                      child: Text(
                        f.format(fechaInicio),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.shade300)),
                      onPressed: () async {
                        DateTime? newFechaFinal = await showDatePicker(
                            context: context,
                            firstDate: fechaInicio,
                            lastDate:  DateTime.now(),
                            initialDate: fechaFinal);
                        if (newFechaFinal == null) return;

                        setState(() {
                          fechaFinal = newFechaFinal;
                          _obtenerPedidos(
                              1, f.format(fechaInicio), f.format(fechaFinal));
                        });
                      },
                      child: Text(
                        f.format(fechaFinal),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: pedidos!.length == 0
                    ? Center(
                        child: Text("Sin Ventas vacio"),
                      )
                    : Column(
                        children: <Widget>[
                          for (var item in pedidos) _crearItem(context, item),
                        ],
                      ),
              ),
            ]),
          ),
        );
      },
    );
  }

  _crearItem(BuildContext context, Pedido pedido) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Row(
                          children: [
                            const Text(
                              textAlign: TextAlign.start,
                              "N°:   ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              pedido!.idPedido.toString(),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          children: [
                            const Text(
                              textAlign: TextAlign.start,
                              "Fecha Registro: ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              textAlign: TextAlign.start,
                              f.format(pedido!.fechaRegistro!),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          children: [
                            const Text(
                              textAlign: TextAlign.start,
                              "Total:   ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              textAlign: TextAlign.start,
                              "S/ ${pedido!.total.toString()}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.amber.shade500)),
                    onPressed: () => {},
                    child: const Icon(
                      Icons.remove_red_eye_sharp,
                      size: 40,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
