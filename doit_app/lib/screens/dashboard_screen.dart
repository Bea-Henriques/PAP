import 'package:doit_app/app_constants.dart';
import 'package:doit_app/models/project_model.dart';
import 'package:doit_app/models/task_model.dart';
import 'package:doit_app/models/user_model.dart';
import 'package:doit_app/screens/delete_account_screen.dart';
import 'package:doit_app/screens/login_screen.dart';
import 'package:doit_app/screens/project_details_screen.dart';
import 'package:doit_app/screens/today_screen.dart';
import 'package:doit_app/services/auth_services.dart';
import 'package:doit_app/services/projects_services.dart';
import 'package:doit_app/services/tasks_services.dart';
import 'package:doit_app/services/users_services.dart';
import 'package:doit_app/widgets/action_row_tile.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:doit_app/widgets/project_card.dart';
import 'package:doit_app/widgets/section_label.dart';
import 'package:doit_app/widgets/stat_card.dart';
import 'package:doit_app/widgets/task_card.dart';
import 'package:doit_app/widgets/task_form.dart';
import 'package:flutter/material.dart';

enum _DashboardTab { dashboard, today, chatbot }
enum _PlannerSection { overview, projects, tasks }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  _DashboardTab _selectedTab = _DashboardTab.dashboard;
  _PlannerSection _section = _PlannerSection.overview;
  final TasksService tasksService = TasksService();
  final ProjectsService projectsService = ProjectsService();
  final AuthService _authService = AuthService();
  final UsersService _usersService = UsersService();

  var totalTasks = 0;
  var completedTasks = 0;
  var totalProjects = 0;

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _usersService.getCurrentUser();

    if (!mounted) return;

    setState(() {
      _currentUser = user;
    });
  }

  final accents = <Color>[
  AppConstants.brandPurple, 
  Color(0xFF5FA8FF),
  Color(0xFF2FAE8F),
  Color(0xFFFFB44C),
  ];

  void _setTab(_DashboardTab tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  void _selectSection(_PlannerSection value) {
    setState(() {
      _section = value;
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleFabPressed() {
    switch (_section) {
      case _PlannerSection.overview:
        _openCreateMenu();
        break;
      case _PlannerSection.projects:
        _openProjectFormSheet();
        break;
      case _PlannerSection.tasks:
        _openTaskFormSheet();
        break;
    }
  }

  IconData _getFabIcon() {
    if (_section == _PlannerSection.projects) return Icons.folder_open_rounded;
    if (_section == _PlannerSection.tasks) return Icons.task_alt_rounded;
    return Icons.add;
  }

  String _getFabLabel() {
    if (_section == _PlannerSection.projects) return 'New Project';
    if (_section == _PlannerSection.tasks) return 'New Task';
    return 'Create';
  }

  InputDecoration _plannerInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFB5B9C8), fontSize: 14),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.04),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppConstants.brandPurple, width: 1.5),
      ),
    );
  }

  void _openProfileMenu() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111318),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppConstants.brandPurple.withValues(alpha: 0.2),
                      child: const CustomText(
                        text: 'B',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppConstants.brandPurple,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: _currentUser?.name ?? 'Utilizador',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 2),
                          CustomText(
                            text: _currentUser?.email ?? 'user@example.com',
                            fontSize: 12,
                            color: const Color(0xFF8A8F9F),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ActionRowTile(
                  icon: Icons.person_outline_rounded,
                  iconColor: AppConstants.brandPurple,
                  title: 'Edit Account',
                  subtitle: 'Update your name.',
                  onTap: () {
                    Navigator.pop(context); // fecha o menu de perfil
                    _openEditNameSheet();
                  },
                ),
                const SizedBox(height: 10),
                ActionRowTile(
                  icon: Icons.delete_outline_rounded,
                  iconColor: AppConstants.brandPurple,
                  title: 'Delete account',
                  subtitle: 'Permanently remove your account and all associated data.',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteAccountScreen(
                      onDelete: () async {
                        final user = await _usersService.getCurrentUser();

                        if (user == null) return;

                        await _usersService.deleteUserDocument(user.uid);
                        await _authService.signOut();

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                    )));
                  },
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 16),
                ActionRowTile(
                  icon: Icons.logout_rounded,
                  iconColor: const Color(0xFFFF5B5B),
                  title: 'Sign out',
                  subtitle: 'Disconnect your account from this device.',
                  onTap: () => _confirmSignOut(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openEditNameSheet() async {
    final nameController = TextEditingController(text: _currentUser?.name ?? '');
    bool isSaving = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111318),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            Future<void> handleSave() async {
              final newName = nameController.text.trim();

              if (newName.isEmpty) {
                ScaffoldMessenger.of(sheetContext).showSnackBar(
                  const SnackBar(content: Text('O nome não pode estar vazio.')),
                );
                return;
              }

              if (_currentUser == null) {
                Navigator.pop(sheetContext);
                return;
              }

              if (newName == _currentUser!.name) {
                Navigator.pop(sheetContext);
                return;
              }

              setSheetState(() => isSaving = true);

              try {
                final updatedUser = User(
                  uid: _currentUser!.uid,
                  name: newName,
                  email: _currentUser!.email,
                );

                await _usersService.updateUser(updatedUser);

                if (!mounted) return;

                setState(() {
                  _currentUser = updatedUser;
                });

                if (sheetContext.mounted) {
                  Navigator.pop(sheetContext);
                  _showMessage('Nome atualizado com sucesso.');
                }
              } catch (e) {
                if (!sheetContext.mounted) return;
                setSheetState(() => isSaving = false);
                ScaffoldMessenger.of(sheetContext).showSnackBar(
                  const SnackBar(content: Text('Não foi possível atualizar o nome.')),
                );
              }
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 18,
                  right: 18,
                  top: 16,
                  bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const CustomText(
                      text: 'Edit name',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      enabled: !isSaving,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      decoration: _plannerInputDecoration('Name'),
                      onSubmitted: (_) => handleSave(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isSaving ? null : () => Navigator.pop(sheetContext),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Colors.white24),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isSaving ? null : handleSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.brandPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmSignOut(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF13151A),
      title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
      content: const Text('Are you sure you want to log out?', style: TextStyle(color: Colors.white70)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            // Lógica de logout aqui
          }, 
          child: const Text('Sign Out', style: TextStyle(color: Color(0xFFFF5B5B))),
        ),
      ],
    ),
  );
}

  void _openCreateMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF111318),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 18),
                const CustomText(
                  text: 'Create New',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                ActionRowTile(
                  icon: Icons.folder_open_rounded,
                  iconColor: AppConstants.brandPurple,
                  title: 'Add Project',
                  subtitle: 'Start structuring a new goal.',
                  onTap: () {
                    Navigator.pop(context);
                    _openProjectFormSheet();
                  },
                ),
                const SizedBox(height: 10),
                ActionRowTile(
                  icon: Icons.task_alt_rounded,
                  iconColor: AppConstants.brandPurple,
                  title: 'Add Task',
                  subtitle: 'Create a pending action for your day.',
                  onTap: () {
                    Navigator.pop(context);
                    _openTaskFormSheet();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openProjectFormSheet() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String chosenDueDate = 'No deadline';
    int colorIndex = 0;

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
                    const CustomText(text: 'New Project', fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                    const SizedBox(height: 24),
                    
                    // Campo: Project Title
                    const CustomText(text: 'Project Title', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'e.g., Mobile App Development',
                        hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.03),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppConstants.brandPurple)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo: Description
                    const CustomText(text: 'Description', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Add project guidelines...',
                        hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.03),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppConstants.brandPurple)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo: Due Date (Estilo InkWell idêntico ao teu formulário de tarefas)
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

                    // Seletor de Cores Minimalista (Combinando com o visual escuro)
                    const CustomText(text: 'Accent Color', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF8A8F9F)),
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(accents.length, (index) {
                        final isSelected = colorIndex == index;
                        return GestureDetector(
                          onTap: () => setSheetState(() => colorIndex = index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: accents[index],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.white : Colors.transparent,
                                width: 2.5,
                              ),
                              boxShadow: isSelected ? [
                                BoxShadow(
                                  color: accents[index].withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                )
                              ] : null,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 28),

                    ElevatedButton(
                      onPressed: () async{
                        if (titleController.text.trim().isEmpty) return;
                        
                        await projectsService.createProject(
                          ProjectModel(
                            id: '', 
                            title: titleController.text.trim(), 
                            description: descriptionController.text.trim(), 
                            dueDate: chosenDueDate, 
                            progress: 0, 
                            colorValue: colorIndex,
                          )
                        );

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.brandPurple,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const CustomText(text: 'Create Project', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openTaskFormSheet({TaskModel? existingTask}) async {
  await TaskForm.show(
    context: context,
    existingTask: existingTask,
    pickDueDate: _pickDueDate,
    onCreate: (task) async {
      await tasksService.createTask(task);
    },
    onUpdate: (task) async {
      await tasksService.updateTask(task);
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

  Widget _buildDashboardAndPlannerView() {
    final hour = DateTime.now().hour;
    final String greeting;
    if (hour < 12) {
      greeting = 'Good morning,';
    } else if (hour < 18) {
      greeting = 'Good afternoon,';
    } else {
      greeting = 'Good evening,';
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: greeting,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8A8F9F),
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    text: _currentUser?.name ?? 'User',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Profile',
              onPressed: _openProfileMenu,
              icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 28),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const CustomText(
          text: "Let's structure your goals and tasks today.",
          fontSize: 13,
          color: Color(0xFFB5B9C8),
        ),
        const SizedBox(height: 20),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SectionPill(
              text: 'Overview',
              selected: _section == _PlannerSection.overview,
              onTap: () => _selectSection(_PlannerSection.overview),
            ),
            _SectionPill(
              text: 'Projects',
              selected: _section == _PlannerSection.projects,
              onTap: () => _selectSection(_PlannerSection.projects),
            ),
            _SectionPill(
              text: 'Tasks',
              selected: _section == _PlannerSection.tasks,
              onTap: () => _selectSection(_PlannerSection.tasks),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Projects',
                value: '$totalProjects',
                subtitle: 'In progress',
                accent: AppConstants.brandPurple, 
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StatCard(
                title: 'Tasks',
                value: '$totalTasks',
                subtitle: 'Pending today',
                accent: Color(0xFF5FA8FF),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StatCard(
                title: 'Completed',
                value: '$completedTasks',
                subtitle: 'This week',
                accent: Color(0xFF2FAE8F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        if (_section == _PlannerSection.overview) ...[
          const SectionLabel(title: 'Recent Projects', subtitle: 'Your current primary focuses'),
          const SizedBox(height: 12),
          _buildProjectList(limit: 2),
          const SizedBox(height: 20),
          const SectionLabel(title: 'Upcoming Tasks', subtitle: 'Urgent and high-priority actions'),
          const SizedBox(height: 12),
          _buildTaskList(limit: 3),
        ],
        if (_section == _PlannerSection.projects) ...[
          const SectionLabel(title: 'All Projects', subtitle: 'General status and overall progress'),
          const SizedBox(height: 12),
          _buildProjectList(),
        ],
        if (_section == _PlannerSection.tasks) ...[
          const SectionLabel(title: 'Task List', subtitle: 'Granular view of your workflow'),
          const SizedBox(height: 12),
          _buildTaskList(),
        ],
      ],
    );
  }

  Widget _buildProjectList({int? limit}) {
    return StreamBuilder<List<ProjectModel>>(
    stream: projectsService.getProjects(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text(
          'No projects yet',
          style: TextStyle(color: Colors.white70),
        );
      }

      var projects = snapshot.data!;

      if (limit != null) {
        projects = projects.take(limit).toList();
      }

      totalProjects = projects.length;

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: projects.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final project = projects[index];

          return ProjectCard(
            title: project.title,
            description: project.description,
            dueDate: project.dueDate,
            progress: project.progress,
            color: accents[project.colorValue],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectDetailsScreen(
                  project: project,
                ),
              ),
            ),
          );
        },
      );
    },
  );
  }

  Color _getPriorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return const Color(0xFFFF5B5B); // vermelho
    case 'medium':
      return const Color(0xFFFFB44C); // laranja
    case 'low':
      return const Color(0xFF2FAE8F); // verde
    default:
      return const Color(0xFF9E9E9E); // cinzento (fallback)
  }
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

 Widget _buildTaskList({int? limit}) {
  return StreamBuilder<List<TaskModel>>(
    stream: tasksService.getTasks(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text(
          'No tasks yet',
          style: TextStyle(color: Colors.white70),
        );
      }

      var tasks = snapshot.data!;

      if (limit != null) {
        tasks = tasks.take(limit).toList();
      }

      totalTasks = tasks.length;
      completedTasks = tasks.where((t) => t.completed).length;

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final task = tasks[index];

          return TaskCard(
            title: task.title,
            dueDate: task.dueDate,
            priority: task.priority,
            priorityColor: _getPriorityColor(task.priority),
            completed: task.completed,
            onTap: () {
              _openTaskFormSheet(existingTask: task);
            },
            onToggle: () {
              tasksService.toggleTask(
                task.id,
                !task.completed,
              );
            },
            onLongPress: () {
            _confirmDeleteTask(task.id);
          },
          );
        },
      );
    },
  );
}

  Widget _buildComingSoonView(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 560),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppConstants.brandPurple.withValues(alpha: 0.18), 
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome_outlined, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 16),
              CustomText(text: title, fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
              const SizedBox(height: 8),
              CustomText(
                text: subtitle,
                fontSize: 13,
                color: const Color(0xFFB8B8B8),
                textAlign: TextAlign.center,
                height: 1.45,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyByTab() {
    switch (_selectedTab) {
      case _DashboardTab.dashboard:
        return _buildDashboardAndPlannerView();
      case _DashboardTab.today:
        return const TodayScreen();
      case _DashboardTab.chatbot:
        return _buildComingSoonView('AI Assistant', 'Your intelligent conversational workspace.');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        floatingActionButton: _selectedTab == _DashboardTab.dashboard
            ? FloatingActionButton.extended(
                backgroundColor: AppConstants.brandPurple, 
                foregroundColor: Colors.white,
                onPressed: _handleFabPressed,
                icon: Icon(_getFabIcon()),
                label: Text(_getFabLabel()),
              )
            : null,
        body: SafeArea(child: _buildBodyByTab()),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF11141A).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavStub(
                    icon: Icons.dashboard_outlined,
                    label: 'Planner',
                    selected: _selectedTab == _DashboardTab.dashboard,
                    onTap: () => _setTab(_DashboardTab.dashboard),
                  ),
                  _NavStub(
                    icon: Icons.today_outlined,
                    label: 'Today',
                    selected: _selectedTab == _DashboardTab.today,
                    onTap: () => _setTab(_DashboardTab.today),
                  ),
                  _NavStub(
                    icon: Icons.smart_toy_outlined,
                    label: 'Chatbot',
                    selected: _selectedTab == _DashboardTab.chatbot,
                    onTap: () => _setTab(_DashboardTab.chatbot),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionPill extends StatelessWidget {
  const _SectionPill({required this.text, required this.selected, required this.onTap});
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? AppConstants.brandPurple : Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: selected ? Colors.white24 : Colors.white12),
        ),
        child: CustomText(
          text: text,
          fontSize: 13,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? Colors.white : const Color(0xFFB5B9C8),
        ),
      ),
    );
  }
}

class _NavStub extends StatelessWidget {
  const _NavStub({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppConstants.brandPurple.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? AppConstants.brandPurple : const Color(0xFF8A8F9F), size: 24),
            const SizedBox(height: 4),
            CustomText(
              text: label,
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? Colors.white : const Color(0xFF8A8F9F),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.decorationBuilder,
    this.maxLines = 1,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final int maxLines;
  final bool readOnly;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final InputDecoration Function(String) decorationBuilder;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: decorationBuilder(label).copyWith(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
        suffixIcon: suffixIcon,
      ),
    );
  }
}