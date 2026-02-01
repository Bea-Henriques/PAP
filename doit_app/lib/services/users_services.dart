import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for handling user-related Firestore operations
class UsersService {
  /// Creates a new user document in Firestore
  /// [uid] - Firebase Auth user ID
  /// [name] - User's display name
  /// [email] - User's email address
  Future<void> createUser(String uid, String name, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'uid': uid,
      'name': name,
      'email': email,
    });
  }
}