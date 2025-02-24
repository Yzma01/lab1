import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    //Login verification
    if (_usernameController.text.isNotEmpty && _usernameController.text == "yzma" &&
        _passwordController.text.isNotEmpty && _passwordController.text == "0101") {
      Navigator.pushReplacementNamed(context, '/ home ');
    } else {
      //Error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(' Por favor , ingrese usuario y contraseña '),
        ),
      );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(' Inicio de Sesión ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //User input
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: ' Usuario ',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            //Password input
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: ' Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            //Loging button
            ElevatedButton(onPressed: _login, child: Text(' Ingresar ')),
          ],
        ),
      ),
    );
  }
}


