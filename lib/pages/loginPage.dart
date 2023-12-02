import 'package:appventa/pages/homePage.dart';
import 'package:appventa/validator/noSpaceFormatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appventa/models/usuario.dart';
import 'package:appventa/service/usuarioService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return _crearMenu('titulo');
  }

  _crearMenu(String titulo) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              child: FormularioLogin(),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// Create a Form widget.
class FormularioLogin extends StatefulWidget {
  const FormularioLogin({super.key});

  @override
  FormularioLoginState createState() {
    return FormularioLoginState();
  }
}

class FormularioLoginState extends State<FormularioLogin> {
  final _formKey = GlobalKey<FormState>();
  // final LoginService =  LoginService();
  Usuario usuario = Usuario.onlyLogin(numeroDocumento: '0', clave: '');
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _agregarImagen(),
              _crearNumeroDocumento(),
              _crearClave(),
              _crearBotonIniciarSesion()
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

  _crearNumeroDocumento() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        inputFormatters: [
          NoSpaceFormatter(),
        ],
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Usuario',
        ),
        validator: (value) {
          if (value == null || value == "") {
            return 'No válido';
          }
          value = value.trim();
        },
        onSaved: (String? value) => usuario.numeroDocumento = value!,
      ),
    );
  }

  _crearClave() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        inputFormatters: [
          NoSpaceFormatter(),
        ],
        obscureText: passwordVisible,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Clave',
          suffixIcon: IconButton(
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(
                    () {
                      passwordVisible = !passwordVisible;
                    },
                  )
          ),
          alignLabelWithHint: false,
          filled: true,
        ),
        validator: (value) {
          if (value == null || value == "") {
            return 'No válido';
          }
          value = value.trim();
        },
        keyboardType: TextInputType.visiblePassword,
        onSaved: (String? value) => usuario.clave = value!,
      ),
    );
  }

  _crearBotonIniciarSesion() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: ElevatedButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          
          _formKey.currentState!.save();
          UsuarioService.iniciarSesion(usuario);
          Navigator.pushReplacementNamed(context, '/home');      
          _formKey.currentState!.reset();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Inicio Sesión')),
          // );
          
        },
        child: const Text('Iniciar Sesión'),
      ),
    );
  }
}
