import 'dart:html';

import 'package:appventa/models/categoria.dart';
import 'package:appventa/pages/productoFormularioPage.dart';
import 'package:appventa/service/categoriaService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appventa/models/producto.dart';
import 'package:appventa/service/productoService.dart';
import 'package:dropdown_search/dropdown_search.dart';

typedef MyBuilder = void Function(
    BuildContext context, void Function() methodFromChild);

GlobalKey<ListaProductoState> globalKey = GlobalKey();

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
  }

  _seleccionarCategoria(int idCategoria) {
    _idCategoria = idCategoria;
    globalKey.currentState?._obtenerProductos(_idCategoria);
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

        return _crearAppBar(categorias!, "Productos");
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
              child: ListaProducto(key: globalKey, idCategoria: _idCategoria),
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
                builder: (context) => const ProductoFormularioPage(
                    title: "Producto Nuevo", idProducto: 0)),
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
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.amber.shade500)),
        onPressed: () => _seleccionarCategoria(categoria.idCategoria),
        child: Text(categoria.nombreCategoria),
      ),
    );
  }
}

// Create a List widget.
class ListaProducto extends StatefulWidget {
  ListaProducto({super.key, required this.idCategoria});
  int? idCategoria;

  @override
  ListaProductoState createState() {
    return ListaProductoState();
  }
}

class ListaProductoState extends State<ListaProducto> {
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
    return StatefulBuilder(builder: (context, setState) {
      return _crearListado();
    });
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
      background: slideLeftBackground(),
      secondaryBackground: slideRightBackground(),
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
        if (direccion == DismissDirection.startToEnd) {
          return _crearAlertConfirmacionEliminar(direccion);
        } else {
          return _crearAlertConfirmacionEditar(direccion, producto);
        }
      },
    );
  }

  Future<bool> _crearAlertConfirmacionEliminar(
      DismissDirection direction) async {
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

  Future<bool> _crearAlertConfirmacionEditar(
      DismissDirection direction, Producto producto) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar"),
          content: const Text("¿Estás seguro de que deseas editar?"),
          actions: <Widget>[
            TextButton(
                onPressed: () => {
                      Navigator.of(context).pop(false),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductoFormularioPage(
                                title: "Producto Editar",
                                idProducto: producto.idProducto)),
                      ).then((value) =>
                          setState(() => _obtenerProductos(idCategoria)))
                    },
                child: const Text("Editar")),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              "Editar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            const Text(
              "Eliminar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
