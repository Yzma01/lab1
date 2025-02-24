import 'package:flutter/material.dart';

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
      body: Center(
        child: Text(
          ' Bienvenido a la aplicación! ',
          style: TextStyle(fontSize: 24),
        ),
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
            //Sign Out
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Salir"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/ ');
              },
            )
          ],
        ),
      ),
    );
  }
}
