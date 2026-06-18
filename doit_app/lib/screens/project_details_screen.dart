import 'package:doit_app/app_constants.dart';
import 'package:doit_app/models/project_model.dart';
import 'package:doit_app/models/task_model.dart';
import 'package:doit_app/screens/edit_project_screen.dart';
import 'package:doit_app/services/tasks_services.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:doit_app/widgets/task_card.dart';
import 'package:flutter/material.dart';

// =========================================================================
// 1. ECRÃ PRINCIPAL: DETALHES DO PROJETO
// =========================================================================
class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({
    super.key,
    required this.project,
  });

  final ProjectModel project;

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  
  final tasksService = TasksService();

  final List<Map<String, dynamic>> _projectTasks = [
    {
      'title': 'Fix global dark mode accent colors',
      'description': 'Update inputs and border opacity to 0.06.',
      'dueDate': 'Today, 14:00',
      'priority': 'High',
      'priorityColor': const Color(0xFFFF5B5B),
      'completed': true,
    },
    {
      'title': 'Review endpoint API contracts',
      'description': 'Check the request bodies with the backend team.',
      'dueDate': 'Tomorrow',
      'priority': 'Medium',
      'priorityColor': const Color(0xFFFFB44C),
      'completed': false,
    },
    {
      'title': 'Optimize local database queries',
      'description': 'Add indexes to the primary tables for faster fetch.',
      'dueDate': 'Jun 12, 2026',
      'priority': 'High',
      'priorityColor': const Color(0xFFFF5B5B),
      'completed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // =========================
    // PROGRESS CORRIGIDO
    // =========================
    final completedCount =
        _projectTasks.where((t) => t['completed'] == true).length;

    final totalCount = _projectTasks.length;

    final double progressPercent =
        totalCount == 0 ? 0.0 : completedCount / totalCount;

    final double clampedProgress = progressPercent.clamp(0.0, 1.0);

    final int progressLabel = widget.project.progress.toInt();

    final Color projectColor = AppConstants.brandPurple;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF21112E), Color(0xFF0F1117)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // =========================
        // APP BAR
        // =========================
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white70),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProjectScreen(project: widget.project),
                  ),
                );
              },
            ),
          ],
        ),

        // =========================
        // BODY
        // =========================
       body: StreamBuilder<List<TaskModel>>(
  stream: tasksService.getTasksByProject(widget.project.id),
  builder: (context, snapshot) {
    final tasks = snapshot.data ?? [];

    final completedCount = tasks.where((t) => t.completed).length;
    final totalCount = tasks.length;

    final progressPercent =
        totalCount == 0 ? 0.0 : completedCount / totalCount;

    final progressLabel = (progressPercent * 100).toInt();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      children: [

        // ================= HEADER =================
        Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppConstants.brandPurple,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            const CustomText(
              text: 'Active Project',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8A8F9F),
            ),
          ],
        ),

        const SizedBox(height: 12),

        CustomText(
          text: widget.project.title,
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),

        const SizedBox(height: 20),

        // ================= PROGRESS =================
        Row(
          children: [
            CustomText(
              text: widget.project.dueDate,
              fontSize: 12,
              color: const Color(0xFF8A8F9F),
            ),
            const Spacer(),
            CustomText(
              text: 'Progress: ',
              fontSize: 13,
              color: const Color(0xFF8A8F9F),
            ),
            CustomText(
              text: '$progressLabel%',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppConstants.brandPurple,
            ),
          ],
        ),

        const SizedBox(height: 12),

        LinearProgressIndicator(
          value: progressPercent,
          backgroundColor: Colors.white12,
          valueColor: const AlwaysStoppedAnimation(
            AppConstants.brandPurple,
          ),
        ),

        const SizedBox(height: 30),

        // ================= TASK HEADER =================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Project Tasks',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                CustomText(
                  text: '$completedCount of $totalCount tasks cleared',
                  fontSize: 12,
                  color: const Color(0xFF8A8F9F),
                ),
              ],
            ),
            ElevatedButton.icon(
  onPressed: _openTaskFormSheet,
  icon: const Icon(Icons.add_rounded, size: 16),
  label: const CustomText(
    text: 'Add Task',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: AppConstants.brandPurple.withValues(alpha: 0.15),
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(
        color: AppConstants.brandPurple.withValues(alpha: 0.35),
      ),
    ),
  ),
)
          ],
        ),

        const SizedBox(height: 16),

        // ================= TASK LIST =================
        if (snapshot.connectionState == ConnectionState.waiting)
          const Center(child: CircularProgressIndicator())
        else if (tasks.isEmpty)
          const Center(
            child: Text(
              'Nenhuma tarefa',
              style: TextStyle(color: Colors.white54),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final task = tasks[index];

              final color = task.priority == 'High'
                  ? const Color(0xFFFF5B5B)
                  : task.priority == 'Medium'
                      ? const Color(0xFFFFB44C)
                      : const Color(0xFF2FAE8F);

              return TaskCard(
                title: task.title,
                dueDate: task.dueDate,
                priority: task.priority,
                priorityColor: color,
                completed: task.completed,
                onToggle: () {
                tasksService.toggleTask(
                  task.id,
                  !task.completed,
                );
                },
                onTap: () {
                  _openTaskFormSheet(existingTask: task);
                },
                onLongPress: () {
                  _confirmDeleteTask(task.id);
                },
              );
            },
          ),
      ],
    );
  },
),
      ),
    );
  }

  void _confirmDeleteTask(String taskId) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF13151A),
      title: const Text(
        'Delete Task',
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'Are you sure you want to delete this task?',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await tasksService.deleteTask(taskId);

            Navigator.pop(context);
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Color(0xFFFF5B5B)),
          ),
        ),
      ],
    ),
  );
}

    Future<void> _openTaskFormSheet({TaskModel? existingTask}) async {
    final isEditing = existingTask != null;

    final titleController = TextEditingController(
    text: existingTask?.title ?? '',
    );

    final descriptionController = TextEditingController(
      text: existingTask?.description ?? '',
    );

    String chosenDueDate = existingTask?.dueDate ?? 'No deadline';
    String selectedPriority = existingTask?.priority ?? 'Medium';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 24,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF13151A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho
                    CustomText(text: isEditing ? 'Edit Task' : 'New Task', fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                    const SizedBox(height: 24),
                    
                    // Campo 1: Task Name
                    const CustomText(text: 'Task Name', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'e.g., Design system alignment',
                        hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.02),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppConstants.brandPurple)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo 2: Description
                    const CustomText(text: 'Description', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Add extra details or guidelines...',
                        hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.02),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppConstants.brandPurple)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo 3: Due Date
                    const CustomText(text: 'Due Date', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final selected = await _pickDueDate(); // Mantém a tua função interna do dashboard
                        if (selected != null) {
                          setSheetState(() => chosenDueDate = selected);
                        }
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.02),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 16, color: Colors.white54),
                            const SizedBox(width: 12),
                            CustomText(
                              text: chosenDueDate, 
                              fontSize: 14, 
                              color: chosenDueDate == 'No deadline' ? Colors.white38 : AppConstants.brandPurple,
                              fontWeight: chosenDueDate == 'No deadline' ? FontWeight.normal : FontWeight.w600,
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.white24),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Campo 4: Priority Level (Cópia exata e fiel da tua página de detalhes)
                    const CustomText(text: 'Priority Level', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF8A8F9F)),
                    const SizedBox(height: 10),
                    Row(
                      children: ['Low', 'Medium', 'High'].map((p) {
                        final isSelected = selectedPriority == p;
                        final Color pColor = p == 'High' 
                            ? const Color(0xFFFF5B5B) 
                            : (p == 'Medium' ? const Color(0xFFFFB44C) : const Color(0xFF2FAE8F));
                        
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setSheetState(() => selectedPriority = p),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? pColor.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.02),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? pColor : Colors.white12),
                              ),
                              child: Center(
                                child: CustomText(
                                  text: p,
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? pColor : Colors.white60,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                    
                    ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.trim().isEmpty) return;

                        if (isEditing) {
                          await tasksService.updateTask(
                            TaskModel(
                              id: existingTask!.id,
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              dueDate: chosenDueDate,
                              priority: selectedPriority,
                              completed: false,
                              projectId: widget.project.id,
                            ),
                          );
                        } else {
                          await tasksService.createTask(
                            TaskModel(
                              id: '',
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              dueDate: chosenDueDate,
                              priority: selectedPriority,
                              completed: false,
                              projectId: widget.project.id,
                            ),
                          );
                        }

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.brandPurple,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: CustomText(
                        text: isEditing ? 'Update Task' : 'Create Task',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _pickDueDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select date',
    );

    if (selectedDate == null) return null;

    final day = selectedDate.day.toString().padLeft(2, '0');
    final month = selectedDate.month.toString().padLeft(2, '0');
    return '$day-$month-${selectedDate.year}';
  }
}