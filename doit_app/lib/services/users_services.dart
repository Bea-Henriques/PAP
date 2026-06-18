import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:doit_app/models/user_model.dart';

/// Service for handling user-related Firestore operations
class UsersService {

  String? userId = FirebaseAuth.instance.currentUser?.uid;

  /// Creates a new user document in Firestore
  /// [newUser] - The user object to create
  Future<void> createUser(User newUser) async {
    await FirebaseFirestore.instance.collection('users').doc(newUser.uid).set({
      'uid': newUser.uid,
      'name': newUser.name.trim(),
      'email': newUser.email.trim(),
    }, SetOptions(merge: true));
  }
  

  /// Fetches a user document by UID and returns a `User` model.
  /// Returns `null` if the document does not exist or on error.
  Future<User?> getUserById(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null) return null;
      return User.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      // ignore: avoid_print
      print('UsersService.getUserById error for uid=$uid: $e');
      return null;
    }
  }

  /// Helper to fetch the currently authenticated user's Firestore document.
  Future<User?> getCurrentUser() async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return getUserById(uid);
  }

  // =========================
  // UPDATE
  // =========================

  /// Atualiza informações do perfil do utilizador no Firestore
  Future<void> updateUser(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'name': user.name.trim(),
      'email': user.email.trim(),
    });
  }

  // =========================
  // DELETE
  // =========================

  /// Elimina o documento do utilizador no Firestore
  Future<void> deleteUserDocument(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
  }

  /// Elimina por completo a conta do utilizador atualmente autenticado:
  /// 1. Remove o documento do Firestore.
  /// 2. Remove a conta no Firebase Authentication.
  ///
  /// Pode lançar [FirebaseAuthException] com código 'requires-recent-login'
  /// se o Firebase exigir reautenticação (login feito há demasiado tempo).
  /// Nesse caso, o ecrã que chama este método deve pedir a password
  /// novamente, reautenticar, e tentar de novo.
  Future<void> deleteCurrentAccount() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    final uid = firebaseUser.uid;

    // Apaga primeiro o documento Firestore, enquanto o user ainda está
    // autenticado (as regras de segurança normalmente exigem isso).
    await deleteUserDocument(uid);

    // Depois apaga a conta de autenticação. Se isto falhar a meio (ex.
    // requires-recent-login), o documento Firestore já foi removido, o que
    // é aceitável: o utilizador terá apenas de voltar a autenticar-se para
    // concluir a eliminação da conta de Auth.
    await firebaseUser.delete();
  }
}