import 'package:flutter/material.dart';
import 'package:lab1/models/user.dart';
import 'package:lab1/services/api_service.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  UserDetailScreen({required this.userId});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _apiService.getUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle de Usuario')),
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error al cargar datos del usuario'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _userFuture = _apiService.getUserById(widget.userId);
                      });
                    },
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(child: Text('Usuario no encontrado'));
          } else {
            final user = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(user),
                  SizedBox(height: 24),
                  _buildInfoSection('Información Personal', [
                    _buildInfoItem(Icons.person, 'Nombre', user.name),
                    _buildInfoItem(
                      Icons.account_circle,
                      'Usuario',
                      user.username,
                    ),
                    _buildInfoItem(Icons.email, 'Email', user.email),
                    _buildInfoItem(Icons.phone, 'Teléfono', user.phone),
                    _buildInfoItem(Icons.web, 'Sitio Web', user.website),
                  ]),
                  SizedBox(height: 24),
                  _buildInfoSection('Dirección', [
                    _buildInfoItem(
                      Icons.location_city,
                      'Ciudad',
                      user.address.city,
                    ),
                    _buildInfoItem(
                      Icons.home,
                      'Calle',
                      '${user.address.street}, ${user.address.suite}',
                    ),
                    _buildInfoItem(
                      Icons.local_post_office,
                      'Código Postal',
                      user.address.zipcode,
                    ),
                    _buildInfoItem(
                      Icons.location_on,
                      'Coordenadas',
                      '${user.address.geo.lat}, ${user.address.geo.lng}',
                    ),
                  ]),
                  SizedBox(height: 24),
                  _buildInfoSection('Empresa', [
                    _buildInfoItem(Icons.business, 'Nombre', user.company.name),
                    _buildInfoItem(
                      Icons.comment,
                      'Frase',
                      user.company.catchPhrase,
                    ),
                    _buildInfoItem(Icons.work, 'BS', user.company.bs),
                  ]),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[700],
            radius: 50,
            child: Text(
              user.name.substring(0, 1),
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          Text(
            user.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            user.email,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(),
        ...children,
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[700]),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(value, style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
