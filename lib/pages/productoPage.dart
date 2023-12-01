import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appventa/models/producto.dart';
import 'package:appventa/service/productoService.dart';

class ProductoPage extends StatefulWidget {
  const ProductoPage({super.key, required this.title});

  final String title;

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: _crearAppBar(widget.title),
      ),
    );
  }

  _crearAppBar(String titulo) {
    return Scaffold(
      appBar: AppBar(
        bottom: const TabBar(
          tabs: [Tab(icon: Icon(Icons.list)), Tab(icon: Icon(Icons.person))]
        ),
        title: Text(titulo)
      ),
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
  // final ProductoService = ProductoService();
  @override
  Widget build(BuildContext context) {
    return _crearListado();
  }

  _crearListado() {
    return FutureBuilder(
      future: ProductoService.obtenerProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
        // WHILE THE CALL IS BEING MADE AKA LOADING
        if (ConnectionState.active != null && !snapshot.hasData) {
          return Center(child: Text('Loading'));
        }

        // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
        if (ConnectionState.done != null && snapshot.hasError) {
          return Center(child: Text("Error"));
        }

        final Productos = snapshot.data;
        return ListView.builder(
          itemCount: Productos?.length,
          itemBuilder: (context, index) {
            _crearItem(context, Productos![index]);
          },
        );
      },
    );
  }

  _crearItem(BuildContext context, Producto Producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete),
      ),
      child: ListTile(
        title: Text('${Producto.nombreProducto}'),
        subtitle: Text(Producto.nombreProducto),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(Producto.nombreProducto[0]),
        ),
        onTap: () =>
            Navigator.pushNamed(context, 'producto', arguments: Producto),
      ),
      onDismissed: (direccion) {
        print(Producto.idProducto);
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
  // final ProductoService =  ProductoService();
  Producto producto =
      Producto(idProducto: 0, nombreProducto: '', precio: 0, stock: 0,idCategoria:0 ,esActivo: false);

  @override
  Widget build(BuildContext context) {
    final Producto? ProductoData =
        ModalRoute.of(context)!.settings.arguments as Producto?;

    if (ProductoData != null) {
      producto = ProductoData;
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _agregarImagen(),
              _crearNombre(),
              _crearPrecio(),
              _crearBotonRegistrar()
            ],
          ),
        ));
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
          labelText: 'Apellidos',
        ),
        validator: (value) {
          if (value == null || value == "") {
            return 'no válido';
          }
          if (value.contains("@")) {
            return "Apellidos no válido";
          }
        },
        onSaved: (String? value) => producto.precio = value! as double,
      ),
    );
  }

  _crearStock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Edad',
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
          if (valor > 100 || valor < 1) {
            return "Edad no válido";
          }
        },
        onSaved: (String? value) => producto.stock = int.parse(value!),
      ),
    );
  }
  _crearCategoria() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Edad',
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
          if (valor > 100 || valor < 1) {
            return "Edad no válido";
          }
        },
        onSaved: (String? value) => producto.idCategoria = int.parse(value!),
      ),
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

          ProductoService.registrarProducto(producto);

          _formKey.currentState!.reset();
        },
        child: const Text('Registrar'),
      ),
    );
  }
}
