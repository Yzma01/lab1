import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user != null) {
        final appUser = AppUser(
          uid: user.uid,
          email: email,
          name: name,
          phone: phone,
          createdAt: DateTime.now(),
        );
        await _db.collection('users').doc(user.uid).set(appUser.toMap());
        return user;
      }
    } catch (e) {
      print("❌ Error en registro: $e");
    }
    return null;
  }

  Future<User?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("❌ Error en login: $e");
      return null;
    }
  }
}
