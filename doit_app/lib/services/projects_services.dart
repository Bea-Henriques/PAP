import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doit_app/models/project_model.dart';

class ProjectsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _projectsRef {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('projects');
  }

  // CREATE
  Future<void> createProject(ProjectModel project) async {
    await _projectsRef.add(project.toMap());
  }

  // READ (STREAM)
  Stream<List<ProjectModel>> getProjects() {
    return _projectsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProjectModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // UPDATE
  Future<void> updateProject(ProjectModel project) async {
    await _projectsRef.doc(project.id).update(project.toMap());
  }

  // DELETE
  Future<void> deleteProject(String id) async {
    await _projectsRef.doc(id).delete();
  }
}