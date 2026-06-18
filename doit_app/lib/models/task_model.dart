import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.completed,
    this.projectId,
  });

  final String id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final bool completed;
  final String? projectId;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'completed': completed,
      'projectId': projectId,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['dueDate'] ?? '',
      priority: map['priority'] ?? 'medium',
      completed: map['completed'] ?? false,
      projectId: map['projectId'] as String?,
    );
  }
}