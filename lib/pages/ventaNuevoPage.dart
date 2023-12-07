import 'dart:html';

import 'package:appventa/models/categoria.dart';
import 'package:appventa/models/producto.dart';
import 'package:appventa/pages/ventaNuevoDetallePage.dart';
import 'package:appventa/service/categoriaService.dart';
import 'package:appventa/service/productoService.dart';
import 'package:appventa/utils/carrito.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appventa/models/Pedido.dart';
import 'package:appventa/service/PedidoService.dart';
import 'package:provider/provider.dart';

GlobalKey<ListadoProductoState> globalKeyFormularioKey = GlobalKey();

class VentaNuevoPage extends StatefulWidget {
  const VentaNuevoPage({super.key, required this.title});

  final String title;

  @override
  State<VentaNuevoPage> createState() => _VentaNuevoPageState();
}

class _VentaNuevoPageState extends State<VentaNuevoPage> {
  final categoriaService = CategoriaService();

  late Future<List<Categoria>> futureCategorias;
  int _idCategoria = 0;

  @override
  void initState() {
    super.initState();
    futureCategorias = categoriaService.obtenerCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureCategorias,
      builder: (BuildContext context, AsyncSnapshot<List<Categoria>> snapshot) {
        // WHILE THE CALL IS BEING MADE AKA LOADING
        if (!snapshot.hasData) {
          return Center(child: Text('Loading'));
        }

        // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
        if (snapshot.hasError) {
          return Center(child: Text("Error"));
        }

        final categorias = snapshot.data;
        categorias?.insert(
            0,
            Categoria(
                idCategoria: 0, nombreCategoria: "Todos", esActivo: true));

        return Consumer<Carrito>(
          builder: (context, carrito, child) {
            return _crearAppBar(categorias!, "Productos", carrito);
          },
        );
      },
    );
    //return _crearMenu(widget.title);
  }

  _crearAppBar(List<Categoria> categorias, String titulo, Carrito carrito) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo), actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              tooltip: 'Cerrar',
              onPressed: () async {
                print(carrito.numeroItems());
                carrito.numeroItems() != 0
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VentaNuevoDetallePage(title: "Carrito")),
                      )
                    : ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(("Agregar un producto"))),
                      );
              },
            ),
            Positioned(
              top: 1,
              // left: 1,
              right: 1,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(25),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 10,
                ),
                child: Text(
                  carrito.numeroItems().toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ]),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categorias!.length,
              itemBuilder: (context, index) {
                return _crearItemCategoria(context, categorias![index]);
              },
            ),
          ),
          Expanded(
            child: ListadoProducto(key: globalKeyFormularioKey, idCategoria: 0),
          )
        ],
      ),
    );
  }

  _crearItemCategoria(BuildContext context, Categoria categoria) {
    return Padding(
      padding: EdgeInsets.all(1),
      child: TextButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.amber.shade500)),
        onPressed: () => _seleccionarCategoria(categoria.idCategoria),
        child: Text(categoria.nombreCategoria),
      ),
    );
  }

  _seleccionarCategoria(int idCategoria) {
    _idCategoria = idCategoria;
    globalKeyFormularioKey.currentState?._obtenerProductos(_idCategoria);
  }

  // _crearMenu(String titulo) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(titulo),
  //       actions: [
  //         IconButton(
  //           icon: const Icon(Icons.shopping_cart_checkout),
  //           tooltip: 'Cerrar',
  //           onPressed: () async {},
  //         ),
  //       ],
  //     ),
  //     body: ListadoProducto(key: globalKey, idCategoria: 0),
  //   );
  // }
}

// Create a List widget.
class ListadoProducto extends StatefulWidget {
  ListadoProducto({super.key, required this.idCategoria});
  int? idCategoria;

  @override
  ListadoProductoState createState() {
    return ListadoProductoState();
  }
}

class ListadoProductoState extends State<ListadoProducto> {
  final pedidoService = PedidoService();
  final productoService = ProductoService();

  late Future<List<Producto>> futureProductos;
  int idCategoria = 0;
  @override
  void initState() {
    super.initState();
    idCategoria = widget.idCategoria ?? 0;
    _obtenerProductos(idCategoria);
  }

  _obtenerProductos(int idCategoria) {
    setState(() {
      futureProductos = productoService.obtenerProductos(idCategoria);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _crearListado();
  }

  _crearListado() {
    return FutureBuilder(
      future: futureProductos,
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
        return Consumer<Carrito>(
          builder: (contextCarrito, carrito, child) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: productos?.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.7),
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return _crearItem(context, productos![index], carrito);
                },
              ),
            );
          },
        );
      },
    );
  }

  _crearItem(BuildContext context, Producto producto, Carrito carrito) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 117, 225, 200),
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(color: Colors.blueAccent),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x000005cc),
                  blurRadius: 20,
                  offset: Offset(10, 10))
            ]),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 60,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    producto.nombreProducto,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
              child: Container(
                padding: const EdgeInsets.only(top: 0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Precio: S/ ${producto.precio.toString()}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: 30,
              child: Container(
                padding: const EdgeInsets.only(top: 0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Stock: ${producto.stock.toString()}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            TextButton.icon(
              icon: const Icon(
                Icons.library_add_outlined,
                size: 24.0,
              ),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.amber.shade500)),
              onPressed: () => _agregarItemCarrito(producto, carrito),
              label: const Text("Agregar"),
            )
          ],
        ),
      ),
      onTap: () {
        print(producto);
      },
    );
  }

  _agregarItemCarrito(Producto producto, Carrito carrito) {
    setState(() {
      carrito.agregarItem(producto, 1);
      carrito.notifyListeners();
    });
  }

  _mostrarSnackBar(SnackBar snackBar) {
    snackBar;
  }
}
