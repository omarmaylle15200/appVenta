import 'package:appventa/global.dart';
import 'package:appventa/models/usuario.dart';
import 'package:appventa/pages/productoPage.dart';
import 'package:flutter/material.dart';

class Page {
  String nombrePage;
  String rutaPage;
  IconData icon;

  Page({required this.nombrePage, required this.rutaPage, required this.icon});
  // can also add 'required' keyword
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Page> pages = [];

  @override
  void initState() {
    super.initState();
    _inicializarPages();
    print(usuarioSesion);
  }

  _inicializarPages() {
    pages.add(Page(
        nombrePage: "Bandeja Producto",
        rutaPage: "/producto",
        icon: Icons.bento));
    pages.add(Page(
        nombrePage: "Realizar Venta",
        rutaPage: "/ventaNuevo",
        icon: Icons.list_alt));
    pages.add(Page(
        nombrePage: "Ventas",
        rutaPage: "/venta",
        icon: Icons.list_alt));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_return_rounded),
            tooltip: 'Cerrar',
            onPressed: () async {
              var value = await _crearAlertConfirmacion();
              // ignore: use_build_context_synchronously
              if (value) Navigator.popAndPushNamed(context, '/');
            },
          ),
        ],
      ),
      body:
          _crearListado(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _crearListado() {
    return GridView.builder(
      itemCount: pages.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2),
          crossAxisSpacing: 30,
          mainAxisSpacing: 30),
      itemBuilder: (context, index) {
        return _crearItem(context, pages[index]);
      },
    );
  }

  _crearItem(BuildContext context, Page page) {
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
              Icon(
                page.icon,
                size: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  textAlign: TextAlign.center,
                  page.nombrePage,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(page.rutaPage);
      },
    );
  }

  Future<bool> _crearAlertConfirmacion() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Salir"),
          content: const Text("¿Estás seguro de que deseas salir?"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  usuarioSesion = Usuario.onlyLogin();
                  Navigator.of(context).pop(true);
                },
                child: const Text("Salir")),
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
