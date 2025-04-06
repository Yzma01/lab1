import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/ home ');
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Ocurrió un error';
      if (e.code == 'user-not-found') {
        message = 'Usuario no encontrado';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showRegisterDialog() {
    final _registerEmail = TextEditingController();
    final _registerPassword = TextEditingController();
    final _registerName = TextEditingController();
    final _registerPhone = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Registrar Usuario"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _registerEmail,
                  decoration: InputDecoration(labelText: 'Correo electrónico'),
                ),
                TextField(
                  controller: _registerPassword,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                ),
                TextField(
                  controller: _registerName,
                  decoration: InputDecoration(labelText: 'Nombre completo'),
                ),
                TextField(
                  controller: _registerPhone,
                  decoration: InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final userCredential = await _auth
                      .createUserWithEmailAndPassword(
                        email: _registerEmail.text.trim(),
                        password: _registerPassword.text.trim(),
                      );

                  final user = userCredential.user;

                  if (user != null) {
                    await _firestore.collection('users').doc(user.uid).set({
                      'email': _registerEmail.text.trim(),
                      'name': _registerName.text.trim(),
                      'phone': _registerPhone.text.trim(),
                      'createdAt': Timestamp.now(),
                    });

                    Navigator.pop(context); // Cierra el diálogo
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Usuario registrado correctamente"),
                      ),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.message}")),
                  );
                }
              },
              child: Text("Registrar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inicio de Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: Text('Ingresar')),
            SizedBox(height: 10),
            TextButton(
              onPressed: _showRegisterDialog,
              child: Text("¿No tienes cuenta? Registrarse"),
            ),
          ],
        ),
      ),
    );
  }
}
