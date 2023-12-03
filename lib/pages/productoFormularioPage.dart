import 'dart:html';

import 'package:appventa/global.dart';
import 'package:appventa/models/categoria.dart';
import 'package:appventa/service/categoriaService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appventa/models/producto.dart';
import 'package:appventa/service/productoService.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ProductoFormularioPage extends StatefulWidget {
  const ProductoFormularioPage(
      {super.key, required this.title, required this.idProducto});

  final String title;
  final int idProducto;

  @override
  State<ProductoFormularioPage> createState() => _ProductoFormularioPageState();
}

class _ProductoFormularioPageState extends State<ProductoFormularioPage> {
  @override
  Widget build(BuildContext context) {
    return _crearMenu("Producto");
  }

  _crearMenu(String titulo) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FormularioProducto(idProducto: widget.idProducto),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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

  int _idProducto = 0;
  late Future<Producto> futureProducto;

  @override
  void initState() {
    super.initState();
    _idProducto = widget.idProducto!;
     _obtenerProducto(_idProducto);
  }

  _obtenerProducto(int idProducto) {
    setState(() {
      futureProducto = productoService.obtenerProducto(idProducto);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureProducto,
      builder: (BuildContext context, AsyncSnapshot<Producto> snapshot) {
        // WHILE THE CALL IS BEING MADE AKA LOADING
        if (!snapshot.hasData) {
          return Center(child: Text('Loading'));
        }

        // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
        if (snapshot.hasError) {
          return Center(child: Text("Error"));
        }

        producto = snapshot.data!;

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
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
      },
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
        initialValue: producto.nombreProducto,
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
        initialValue: producto.precio.toString(),
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
        initialValue: producto.stock.toString(),
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

        if (_idProducto != 0)
          categoria = categorias
              .firstWhere((x) => x.idCategoria == producto.idCategoria);

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
          selectedItem: categoria,
          onSaved: (Categoria? categoria) =>
              producto.idCategoria = categoria!.idCategoria,
          validator: (Categoria? i) {
            if (i == null) {
              return 'Categoria no válida';
            }
            if (i.idCategoria == 0) {
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
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          _formKey.currentState!.save();

          producto.idUsuarioRegistro = usuarioSesion.idUsuario;
          producto.idUsuarioActualizacion = usuarioSesion.idUsuario;

          bool resp = false;
          if (_idProducto == 0) {
            resp = await productoService.registrarProducto(producto);
          } else {
            resp = await productoService.actualizarProducto(producto);
          }

          if (!resp) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text((_idProducto==0?'Error al registrar':'Error al actualizar'))),
            );
            return;
          }

          _formKey.currentState!.reset();

          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
        child: _idProducto == 0
            ? const Text('Registrar')
            : const Text('Actualizar'),
      ),
    );
  }
}
