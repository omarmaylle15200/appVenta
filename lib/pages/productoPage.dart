import 'dart:html';

import 'package:appventa/models/categoria.dart';
import 'package:appventa/service/categoriaService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appventa/models/producto.dart';
import 'package:appventa/service/productoService.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ProductoPage extends StatefulWidget {
  const ProductoPage({super.key, required this.title});

  final String title;

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
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
          ListaProducto(),
          FormularioProducto(),
        ],
      ),
    );
  }
}

// Create a List widget.
class ListaProducto extends StatefulWidget {
  const ListaProducto({super.key});

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
    futureProductos = productoService.obtenerProductos();
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
          child: Text(""),
        ),
        onTap: () =>
            Navigator.pushNamed(context, '/producto', arguments: producto),
      ),
      onDismissed: (direccion) {
        print(producto.idProducto);
      },
    );
  }
}

// Create a Form widget.
class FormularioProducto extends StatefulWidget {
  const FormularioProducto({super.key, this.idProducto});
  final int? idProducto;

  @override
  FormularioProductoState createState() {
    return FormularioProductoState();
  }
}

class FormularioProductoState extends State<FormularioProducto> {
  final _formKey = GlobalKey<FormState>();
  final productoService = ProductoService();
  final categoriaService = CategoriaService();

  Producto producto = Producto(
      idProducto: 0,
      nombreProducto: '',
      precio: 0.0,
      stock: 0,
      idCategoria: 0,
      esActivo: false);
  Categoria categoria =
      Categoria(idCategoria: 0, nombreCategoria: '', esActivo: true);

  @override
  Widget build(BuildContext context) {
    final Producto? ProductoData =
        ModalRoute.of(context)!.settings.arguments as Producto?;

    if (ProductoData != null) {
      producto = ProductoData;
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //_agregarImagen(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearStock(),
                  _crearCategoria(),
                  _crearBotonRegistrar()
                ],
              ),
            )),
      ),
    );
  }

  _agregarImagen() {
    return const Image(
      image: AssetImage('assets/images/user.png'),
      height: 200,
      width: 200,
    );
  }

  _crearNombre() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Nombre',
        ),
        validator: (value) {
          if (value == null || value == "") {
            return 'no válido';
          }
          if (value.contains("@")) {
            return "Nombre no válido";
          }
        },
        onSaved: (String? value) => producto.nombreProducto = value!,
      ),
    );
  }

  _crearPrecio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Precio',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        validator: (value) {
          if (value == null || value == "") {
            return 'no válido';
          }
          double valor = double.parse(value);
          if (valor < 1) {
            return "Precio no válido";
          }
        },
        onSaved: (String? value) => producto.precio = double.parse(value!),
      ),
    );
  }

  _crearStock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Stock',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        validator: (value) {
          if (value == null || value == "") {
            return 'no válido';
          }
          int valor = int.parse(value);
          if (valor < 1) {
            return "Stock no válido";
          }
        },
        onSaved: (String? value) => producto.stock = int.parse(value!),
      ),
    );
  }

  void itemSelectionChanged(Categoria? _categoria) {
    categoria = _categoria!;
  }

  _crearCategoria() {
    return FutureBuilder(
      future: categoriaService.obtenerCategorias(),
      builder: (BuildContext context, AsyncSnapshot<List<Categoria>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Text('Loading'));
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }

        final categorias = snapshot.data ?? [];

        return DropdownSearch<Categoria>(
          items: categorias,
          itemAsString: (Categoria categoria) => categoria.nombreCategoria,
          popupProps: PopupPropsMultiSelection.modalBottomSheet(
            itemBuilder: _genererarItemPopUp,
            showSearchBox: true,
          ),
          onChanged: itemSelectionChanged,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Categoria",
              hintText: "::Selecciona Categoria::",
            ),
          ),
          onSaved: (Categoria? categoria) =>
              producto.idCategoria = categoria!.idCategoria,
          validator: (Categoria? i) {
            if (i == null) {
              return 'Categoria no válida';
            } 
          },
        );
      },
    );
  }

  Widget _genererarItemPopUp(
      BuildContext context, Categoria item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
          selected: isSelected,
          title: Text(item.nombreCategoria),
          subtitle: Text(item.nombreCategoria.toString())),
    );
  }

  _crearBotonRegistrar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: ElevatedButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registrando')),
          );

          _formKey.currentState!.save();

          productoService.registrarProducto(producto);

          _formKey.currentState!.reset();
        },
        child: const Text('Registrar'),
      ),
    );
  }
}
