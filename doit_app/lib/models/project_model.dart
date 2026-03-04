class Project{
  final String? id;
  final String title;
  final String? description;
  final DateTime? startDate;
  final DateTime? dueDate;
  final String status;
  final int userId;

  const Project({
    this.id,
    required this.title,
    this.description,
    this.startDate,
    this.dueDate,
    required this.status,
    required this.userId,
  });
}