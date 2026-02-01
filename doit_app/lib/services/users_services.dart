import 'package:cloud_firestore/cloud_firestore.dart';

class UsersService {
  Future<void> createUser(String uid, String name, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'uid': uid,
      'name': name,
      'email': email,
    });
  }
}