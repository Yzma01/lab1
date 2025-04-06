import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/app_user.dart';

class UserService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<AppUser?> fetchUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    return AppUser.fromMap(uid, doc.data()!);
  }

  Future<String?> uploadProfileImage(File file) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final ref = _storage.ref().child('profile_pictures/$uid.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    await _firestore.collection('users').doc(uid).update({'photoUrl': url});
    return url;
  }
}
