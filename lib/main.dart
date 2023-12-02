import 'package:appventa/pages/loginPage.dart';
import 'package:appventa/pages/productoFormularioPage.dart';
import 'package:appventa/pages/productoPage.dart';
import 'package:appventa/pages/ventaPage.dart';
import 'package:flutter/material.dart';
import 'package:appventa/pages/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const LoginPage(title: 'Login'),
        '/home': (context) => const MyHomePage(title: 'Home'),
        '/producto': (context) => const ProductoPage(title: 'Producto'),
        '/productoFormulario': (context) => const ProductoFormularioPage(title: 'Producto Formulario'),
        '/venta': (context) => const VentaPage(title: 'Venta'),
        '/ventaNuevo': (context) => const VentaPage(title: 'Venta'),
      },
    );
  }
}
