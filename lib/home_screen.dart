import 'package:flutter/material.dart';
import 'package:lab1/api/api.dart';
import 'package:lab1/api/user_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //NavBar
        title: Text(' Home '),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/ profile ');
            },
          ),
        ],
      ),
       body: FutureBuilder<List<dynamic>>(
        future: requestUsers(), // Llamamos a la API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          } else {
            return UserWidget(users: snapshot.data!);
          }
        },
      ),
      //SideBar
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            //Header SideBar
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Inicio',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            //Home
            ListTile(
              leading: Icon(Icons.home),
              title: Text(' Home '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            //Profile
            ListTile(
              leading: Icon(Icons.person),
              title: Text(' Perfil '),
              onTap: () {
                Navigator.pushNamed(context, '/ profile ');
              },
            ),
            //Map
            ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text("Mapa"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/ map');
              },
            ),
            //Sign Out
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Salir"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/ ');
              },
            ),
          ],
        ),
      ),
    );
  }
}
