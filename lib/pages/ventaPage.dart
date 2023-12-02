import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appventa/models/Pedido.dart';
import 'package:appventa/service/PedidoService.dart';

class VentaPage extends StatefulWidget {
  const VentaPage({super.key, required this.title});

  final String title;

  @override
  State<VentaPage> createState() => _VentaPageState();
}

class _VentaPageState extends State<VentaPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: _crearAppBar(widget.title),
    );
  }

  _crearAppBar(String titulo) {
    return Scaffold(
      appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.list)),
            Tab(icon: Icon(Icons.person))
          ]),
          title: Text(titulo)),
      body: const TabBarView(
        children: [
          ListaPedido()
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return _crearListado();
  }

  _crearListado() {
    return FutureBuilder(
      future: pedidoService.obtenerPedidos(),
      builder: (BuildContext context, AsyncSnapshot<List<Pedido>> snapshot) {
        // WHILE THE CALL IS BEING MADE AKA LOADING
        if (!snapshot.hasData) {
          return Center(child: Text('Loading'));
        }

        // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
        if (snapshot.hasError) {
          return Center(child: Text("Error"));
        }

        final Pedidos = snapshot.data;
        return ListView.builder(
          itemCount: Pedidos?.length,
          itemBuilder: (context, index) {
            _crearItem(context, Pedidos![index]);
          },
        );
      },
    );
  }

  _crearItem(BuildContext context, Pedido pedido) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete),
      ),
      child: ListTile(
        title: Text('${pedido.idPedido.toString()}'),
        subtitle: Text(pedido.idPedido.toString()),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(pedido.idPedido.toString()),
        )
      ),
      onDismissed: (direccion) {
        print(pedido.idPedido);
      },
    );
  }
}
