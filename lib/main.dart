import 'package:appventa/pages/loginPage.dart';
import 'package:appventa/pages/productoFormularioPage.dart';
import 'package:appventa/pages/productoPage.dart';
import 'package:appventa/pages/ventaNuevoPage.dart';
import 'package:appventa/pages/ventaPage.dart';
import 'package:appventa/utils/carrito.dart';
import 'package:flutter/material.dart';
import 'package:appventa/pages/homePage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Carrito(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const LoginPage(title: 'Login'),
          '/home': (context) => const MyHomePage(title: 'Inicio'),
          '/producto': (context) => const ProductoPage(title: 'Producto'),
          '/productoFormulario': (context) => const ProductoFormularioPage(
              title: 'Producto Formulario', idProducto: 0),
          '/venta': (context) => const VentaPage(title: 'Venta'),
          '/ventaNuevo': (context) =>
              const VentaNuevoPage(title: 'Nueva venta'),
        });
  }
}
