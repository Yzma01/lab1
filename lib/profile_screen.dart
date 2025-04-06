import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/user_service.dart';
import '../models/app_user.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userData = await UserService().fetchUserData();
    setState(() {
      _user = userData;
      _loading = false;
    });
  }

  Future<void> _selectAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      final url = await UserService().uploadProfileImage(file);
      if (url != null) {
        await _loadUser();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Imagen actualizada')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : _user == null
              ? Center(child: Text("Usuario no encontrado"))
              : Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _selectAndUploadImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  _user!.photoUrl != null
                                      ? NetworkImage(_user!.photoUrl!)
                                      : null,
                              child:
                                  _user!.photoUrl == null
                                      ? Icon(Icons.person, size: 50)
                                      : null,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            _user!.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            _user!.email,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Teléfono: ${_user!.phone}",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Volver"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
