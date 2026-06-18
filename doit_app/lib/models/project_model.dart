class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.progress,
    required this.colorValue,
  });

  final String id;
  final String title;
  final String description;
  final String dueDate;
  final double progress;
  final int colorValue;

  Map<String, dynamic> toMap() {
  return {
    'title': title,
    'description': description,
    'dueDate': dueDate,
    'progress': progress,
    'colorValue': colorValue,
  };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map, String id) {
    return ProjectModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['dueDate'] ?? '',
      progress: map['progress'] ?? '',
      colorValue: map['colorValue'] ?? 0,
    );
  }
}