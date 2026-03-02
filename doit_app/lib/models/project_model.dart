class Project{
  final String? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final String status;

  const Project({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.status,
  });
}