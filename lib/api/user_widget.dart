import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final List<dynamic> users;

  const UserWidget({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final lat = user['address']['geo']['lat'];
        final lng = user['address']['geo']['lng'];

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                user['name'][0], // Primera letra del nombre
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${user['username']}'),
                Text(user['email'], style: const TextStyle(color: Colors.blue)),
                Text('📍 ${user['address']['city']}'),
                Text('🏢 ${user['company']['name']}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: () {
              // Puedes definir una acción al tocar la tarjeta
              print('Clicked on $lat  $lng ${user['name']}');
            },
          ),
        );
      },
    );
  }
}
