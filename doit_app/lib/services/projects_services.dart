import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PojectsService{
  final user = FirebaseAuth.instance.currentUser; // get current user
  final CollectionReference projects = FirebaseFirestore.instance.collection('projects'); // get collection of projects

  // CREATE

  // READ
  // UPDATE
  // DELETE
}