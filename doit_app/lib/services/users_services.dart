import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersService {
  final uid = FirebaseAuth.instance.currentUser!.uid; // Get user id

  Future addUsers(String name, String email) async{
    await FirebaseFirestore.instance.collection('users').add({
      'uid': uid,
      'name': name,
      'email': email,
    });
  }
}