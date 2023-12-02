import 'dart:html';

import 'package:appventa/models/producto.dart';
import 'package:appventa/service/productoService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appventa/models/Pedido.dart';
import 'package:appventa/service/PedidoService.dart';

class VentaNuevoPage extends StatefulWidget {
  const VentaNuevoPage({super.key, required this.title});

  final String title;

  @override
  State<VentaNuevoPage> createState() => _VentaNuevoPageState();
}

class _VentaNuevoPageState extends State<VentaNuevoPage> {
  @override
  Widget build(BuildContext context) {
    return _crearMenu(widget.title);
  }

  _crearMenu(String titulo) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              child: FormularioVenta(),
            ),
          ],
        ),
      ),
    );
  }
}

// Create a List widget.
class FormularioVenta extends StatefulWidget {
  const FormularioVenta({super.key});

  @override
  FormularioVentaState createState() {
    return FormularioVentaState();
  }
}

class FormularioVentaState extends State<FormularioVenta> {
  final pedidoService = PedidoService();
  final productoService = ProductoService();

  @override
  Widget build(BuildContext context) {
    return _crearListado();
  }

  _crearListado() {
    return FutureBuilder(
      future: productoService.obtenerProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
        // WHILE THE CALL IS BEING MADE AKA LOADING
        if (!snapshot.hasData) {
          return Center(child: Text('Loading'));
        }

        // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
        if (snapshot.hasError) {
          return Center(child: Text("Error"));
        }

        final productos = snapshot.data;
        return GridView.builder(
          itemCount: productos?.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.1),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemBuilder: (context, index) {
            return _crearItem(context, productos![index]);
          },
        );
      },
    );
  }

  _crearItem(BuildContext context, Producto producto) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow:const [
            BoxShadow(
                color: Color(0x000005cc),
                blurRadius: 30,
                offset: Offset(10, 10))
          ]),
      child: Column(
        children: <Widget>[
          Text(
            producto.nombreProducto,
            style:const TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding:const EdgeInsets.only(top:20),
            child:Text(
              producto.precio.toString(),
              style:const TextStyle(fontSize: 16),
            )
          ),
          
        ],
      ),
    );
  }
}
