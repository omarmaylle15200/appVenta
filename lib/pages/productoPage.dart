import 'dart:html';

import 'package:appventa/models/categoria.dart';
import 'package:appventa/pages/productoFormularioPage.dart';
import 'package:appventa/service/categoriaService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appventa/models/producto.dart';
import 'package:appventa/service/productoService.dart';
import 'package:dropdown_search/dropdown_search.dart';

typedef MyBuilder = void Function(BuildContext context, void Function() methodFromChild);


class ProductoPage extends StatefulWidget {
  const ProductoPage({super.key, required this.title});

  final String title;

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final categoriaService = CategoriaService();

  late Future<List<Categoria>> futureCategorias;
  int _idCategoria = 0;

  @override
  void initState() {
    super.initState();
    futureCategorias = categoriaService.obtenerCategorias();
    _idCategoria = 0;
  }

  _seleccionarCategoria(int idCategoria) {
    setState(() {
      _idCategoria = idCategoria;
    });
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

        return _crearAppBar(categorias!, "");
      },
    );
  }

  _crearAppBar(List<Categoria> categorias, String titulo) {
    return Scaffold(
        appBar: AppBar(title: Text(titulo)),
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
              child: ListaProducto(idCategoria: _idCategoria),
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 50.0),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProductoFormularioPage(title: "")),
          ),
          tooltip: 'Nuevo',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }

  _crearItemCategoria(BuildContext context, Categoria categoria) {
    return Padding(
      padding: EdgeInsets.all(1),
      child: TextButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow)),
        onPressed: () => _seleccionarCategoria(categoria.idCategoria),
        child: Text(categoria.nombreCategoria),
      ),
    );
  }
}

// Create a List widget.
class ListaProducto extends StatefulWidget {
  ListaProducto({super.key,  required this.idCategoria});
  int idCategoria;

  @override
  ListaProductoState createState() {
    return ListaProductoState();
  }
}

class ListaProductoState extends State<ListaProducto> {
  final productoService = ProductoService();

  late Future<List<Producto>> futureProductos;

  @override
  void initState() {
    super.initState();
    _obtenerProductos();
  }

  _obtenerProductos() {
    setState(() {
      futureProductos = productoService.obtenerProductos(widget.idCategoria!);
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
        return ListView.builder(
          itemCount: productos?.length,
          itemBuilder: (context, index) {
            return _crearItem(context, productos![index]);
          },
        );
      },
    );
  }

  _crearItem(BuildContext context, Producto producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete),
      ),
      child: ListTile(
        title: Text(producto.nombreProducto),
        subtitle: Text(producto.nombreProducto),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.indeterminate_check_box),
        ),
        onTap: () => print(producto),
      ),
      confirmDismiss: (direccion) {
        return _crearAlertConfirmacion(direccion);
      },
    );
  }

  Future<bool> _crearAlertConfirmacion(DismissDirection direction) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar"),
          content: const Text("¿Estás seguro de que deseas eliminar?"),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Eliminar")),
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
