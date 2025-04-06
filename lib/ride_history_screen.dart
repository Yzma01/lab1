import 'package:flutter/material.dart';
import '../models/ride.dart';
import '../services/ride_service.dart';
import 'package:intl/intl.dart';

class RideHistoryScreen extends StatelessWidget {
  final RideService _rideService = RideService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historial de Viajes")),
      body: StreamBuilder<List<Ride>>(
        stream: _rideService.getUserRides(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final rides = snapshot.data ?? [];

          if (rides.isEmpty) {
            return Center(child: Text("No hay viajes registrados."));
          }

          return ListView.builder(
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  leading: Icon(Icons.directions_car),
                  title: Text('${ride.origen} → ${ride.destino}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('dd/MM/yyyy hh:mm a').format(ride.fecha)),
                      if (ride.comentario.isNotEmpty) Text(ride.comentario),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("⭐ ${ride.rating}"), Text(ride.estado)],
                  ),
                  isThreeLine: ride.comentario.isNotEmpty,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _rideService.addSimulatedRide();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Viaje simulado agregado")));
        },
        label: Text("Agregar Viaje"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
