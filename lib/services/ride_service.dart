import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ride.dart';

class RideService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addSimulatedRide() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('rides').add({
      'userId': user.uid,
      'origen': 'Pérez Zeledón',
      'destino': 'Golfito',
      'fecha': Timestamp.now(),
      'estado': 'finalizado',
      'comentario': 'Viaje rápido y cómodo.',
      'rating': 5,
    });
  }

  Stream<List<Ride>> getUserRides() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('rides')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Ride.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }
}
