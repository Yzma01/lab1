import 'package:cloud_firestore/cloud_firestore.dart';

class Ride {
  final String id;
  final String userId;
  final String origen;
  final String destino;
  final DateTime fecha;
  final String estado;
  final String comentario;
  final int rating;

  Ride({
    required this.id,
    required this.userId,
    required this.origen,
    required this.destino,
    required this.fecha,
    required this.estado,
    required this.comentario,
    required this.rating,
  });

  factory Ride.fromMap(String id, Map<String, dynamic> data) {
    return Ride(
      id: id,
      userId: data['userId'] ?? '',
      origen: data['origen'] ?? '',
      destino: data['destino'] ?? '',
      fecha: (data['fecha'] as Timestamp).toDate(),
      estado: data['estado'] ?? '',
      comentario: data['comentario'] ?? '',
      rating: data['rating'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'origen': origen,
      'destino': destino,
      'fecha': fecha,
      'estado': estado,
      'comentario': comentario,
      'rating': rating,
    };
  }
}
