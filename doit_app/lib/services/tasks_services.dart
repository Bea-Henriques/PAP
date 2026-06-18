import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doit_app/models/task_model.dart';

class TasksService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _uid {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _tasksRef {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('tasks');
  }

  // =========================
  // CREATE
  // =========================

  Future<void> createTask(TaskModel task) async {
    await _tasksRef.add(task.toMap());
  }

  // =========================
  // READ ALL TASKS
  // =========================

  Stream<List<TaskModel>> getTasks() {
  return _tasksRef.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return TaskModel.fromMap(doc.data(), doc.id);
    }).toList();
  });
}

  // =========================
  // READ PROJECT TASKS
  // =========================

  Stream<List<TaskModel>> getTasksByProject(
    String projectId,
  ) {
    return _tasksRef
        .where('projectId', isEqualTo: projectId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  // =========================
  // READ STANDALONE TASKS
  // =========================

  Stream<List<TaskModel>> getStandaloneTasks() {
    return _tasksRef
        .where('projectId', isEqualTo: '')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  // =========================
  // UPDATE
  // =========================

  Future<void> updateTask(
    TaskModel task,
  ) async {
    await _tasksRef
        .doc(task.id)
        .update(task.toMap());
  }

  // =========================
  // DELETE
  // =========================

  Future<void> deleteTask(
    String id,
  ) async {
    await _tasksRef
        .doc(id)
        .delete();
  }

  // =========================
  // DELETE ALL PROJECT TASKS
  // =========================

  Future<void> deleteTasksByProject(
    String projectId,
  ) async {
    final snapshot = await _tasksRef
        .where('projectId', isEqualTo: projectId)
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // =========================
  // TOGGLE COMPLETE
  // =========================

  Future<void> toggleTask(
    String id,
    bool value,
  ) async {
    await _tasksRef
        .doc(id)
        .update({
      'completed': value,
    });
  }
}