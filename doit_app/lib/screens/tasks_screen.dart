import 'package:doit_app/app_constants.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Finalizar wireframe da dashboard',
      'description': 'Ajustar estados e alinhamentos principais.',
      'priority': 'Alta',
      'dueDate': '15/05/2026',
      'isCompleted': false,
    },
    {
      'title': 'Rever documentação do projeto',
      'description': 'Validar conteúdo e corrigir pequenas falhas.',
      'priority': 'Média',
      'dueDate': '18/05/2026',
      'isCompleted': false,
    },
    {
      'title': 'Implementar CRUD de tarefas',
      'description': 'Criar a versão local com editar e eliminar.',
      'priority': 'Alta',
      'dueDate': '12/05/2026',
      'isCompleted': true,
    },
  ];

  void _openTaskForm({int? index}) {
    final isEditing = index != null;
    final task = isEditing ? _tasks[index] : <String, dynamic>{};

    String title = task['title'] as String? ?? '';
    String description = task['description'] as String? ?? '';
    String dueDate = task['dueDate'] as String? ?? '';
    String priority = task['priority'] as String? ?? 'Média';
    bool isCompleted = task['isCompleted'] as bool? ?? false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                top: 18,
                bottom: MediaQuery.of(context).viewInsets.bottom + 18,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    CustomText(
                      text: isEditing ? 'Editar tarefa' : 'Nova tarefa',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    const CustomText(
                      text: 'Tudo fica apenas nesta tela, com estado local.',
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 18),
                    _FormField(
                      initialValue: title,
                      label: 'Título',
                      hintText: 'Ex.: Finalizar protótipo',
                      onChanged: (value) => title = value,
                    ),
                    const SizedBox(height: 12),
                    _FormField(
                      initialValue: description,
                      label: 'Descrição',
                      hintText: 'Descreve rapidamente a tarefa',
                      maxLines: 3,
                      onChanged: (value) => description = value,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _FormField(
                            key: ValueKey(dueDate),
                            initialValue: dueDate,
                            label: 'Prazo',
                            hintText: 'dd/mm/aaaa',
                            readOnly: true,
                            suffixIcon: const Icon(Icons.calendar_month_outlined),
                            onTap: () async {
                              final selectedDate = await _pickDueDate(
                                initialValue: dueDate,
                              );

                              if (selectedDate == null) {
                                return;
                              }

                              setSheetState(() {
                                dueDate = selectedDate;
                              });
                            },
                            onChanged: (value) => dueDate = value,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: priority,
                            dropdownColor: const Color(0xFF1E1E1E),
                            decoration: _inputDecoration('Prioridade'),
                            style: const TextStyle(color: Colors.white),
                            items: const [
                              DropdownMenuItem(
                                value: 'Baixa',
                                child: Text('Baixa'),
                              ),
                              DropdownMenuItem(
                                value: 'Média',
                                child: Text('Média'),
                              ),
                              DropdownMenuItem(
                                value: 'Alta',
                                child: Text('Alta'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setSheetState(() => priority = value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: CustomText(
                              text: 'Marcar como concluída',
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          Switch.adaptive(
                            value: isCompleted,
                            activeThumbColor: AppConstants.brandPurple,
                            onChanged: (value) {
                              setSheetState(() => isCompleted = value);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.brandPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          final trimmedTitle = title.trim();
                          final trimmedDescription = description.trim();
                          final trimmedDueDate = dueDate.trim();

                          if (trimmedTitle.isEmpty || trimmedDescription.isEmpty || trimmedDueDate.isEmpty) {
                            return;
                          }

                          setState(() {
                            final payload = {
                              'title': trimmedTitle,
                              'description': trimmedDescription,
                              'priority': priority,
                              'dueDate': trimmedDueDate,
                              'isCompleted': isCompleted,
                            };

                            if (isEditing) {
                              _tasks[index] = payload;
                            } else {
                              _tasks.insert(0, payload);
                            }
                          });

                          Navigator.pop(context);
                        },
                        child: Text(isEditing ? 'Guardar alterações' : 'Criar tarefa'),
                      ),
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

  void _deleteTask(int index) {
    setState(() => _tasks.removeAt(index));
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['isCompleted'] = !(_tasks[index]['isCompleted'] as bool? ?? false);
    });
  }

  Future<String?> _pickDueDate({required String initialValue}) async {
    final initialDate = _parseDate(initialValue) ?? DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Selecionar prazo',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (selectedDate == null) {
      return null;
    }

    return _formatDate(selectedDate);
  }

  DateTime? _parseDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) {
      return null;
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return null;
    }

    return DateTime(year, month, day);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  static InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.04),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppConstants.brandPurple),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingTasks = _tasks.asMap().entries.where((entry) {
      return entry.value['isCompleted'] != true;
    }).toList();
    final completedTasks = _tasks.asMap().entries.where((entry) {
      return entry.value['isCompleted'] == true;
    }).toList();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppConstants.brandPurple, Colors.black],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const CustomText(
            text: 'Tarefas',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: 'Resumo das tarefas',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _SummaryChip(
                        label: 'Total',
                        value: '${_tasks.length}',
                      ),
                      const SizedBox(width: 10),
                      _SummaryChip(
                        label: 'Concluídas',
                        value: '${completedTasks.length}',
                      ),
                      const SizedBox(width: 10),
                      _SummaryChip(
                        label: 'Pendentes',
                        value: '${pendingTasks.length}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (pendingTasks.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.task_alt_outlined, color: Colors.white54, size: 44),
                    SizedBox(height: 12),
                    CustomText(
                      text: 'Ainda não há tarefas.',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    SizedBox(height: 6),
                    CustomText(
                      text: 'Carrega no + para criar a primeira.',
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ],
                ),
              )
            else
              ...List.generate(pendingTasks.length, (index) {
                final entry = pendingTasks[index];
                final task = entry.value;
                final originalIndex = entry.key;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _TaskCard(
                    title: task['title'] as String,
                    description: task['description'] as String,
                    priority: task['priority'] as String,
                    dueDate: task['dueDate'] as String,
                    isCompleted: task['isCompleted'] as bool? ?? false,
                    onEdit: () => _openTaskForm(index: originalIndex),
                    onDelete: () => _deleteTask(originalIndex),
                    onToggleComplete: () => _toggleTaskCompletion(originalIndex),
                  ),
                );
              }),
            if (completedTasks.isNotEmpty) ...[
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white12),
                ),
                child: ExpansionTile(
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white70,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  title: CustomText(
                    text: 'Concluídas (${completedTasks.length})',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  subtitle: const CustomText(
                    text: 'Tarefas arquivadas nesta sessão',
                    fontSize: 11,
                    color: Colors.white54,
                  ),
                  children: [
                    ...List.generate(completedTasks.length, (index) {
                      final entry = completedTasks[index];
                      final task = entry.value;
                      final originalIndex = entry.key;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _TaskCard(
                          title: task['title'] as String,
                          description: task['description'] as String,
                          priority: task['priority'] as String,
                          dueDate: task['dueDate'] as String,
                          isCompleted: task['isCompleted'] as bool? ?? false,
                          onEdit: () {
                            _openTaskForm(index: originalIndex);
                          },
                          onDelete: () {
                            _deleteTask(originalIndex);
                          },
                          onToggleComplete: () {
                            _toggleTaskCompletion(originalIndex);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppConstants.brandPurple,
          foregroundColor: Colors.white,
          onPressed: _openTaskForm,
          icon: const Icon(Icons.add),
          label: const Text('Nova tarefa'),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.isCompleted,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
  });

  final String title;
  final String description;
  final String priority;
  final String dueDate;
  final bool isCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  Color get _priorityColor {
    switch (priority) {
      case 'Alta':
        return const Color(0xFFE57373);
      case 'Média':
        return const Color(0xFFFFD54F);
      default:
        return const Color(0xFF81C784);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onToggleComplete,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppConstants.brandPurple : Colors.white38,
                ),
                color: isCompleted
                    ? AppConstants.brandPurple
                    : Colors.transparent,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? Colors.white54 : Colors.white,
                  // textDecoration: isCompleted
                  //     ? TextDecoration.lineThrough
                  //     : TextDecoration.none,
                ),
                const SizedBox(height: 6),
                CustomText(
                  text: description,
                  fontSize: 12,
                  color: Colors.white54,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white38,
                      size: 11,
                    ),
                    const SizedBox(width: 4),
                    CustomText(
                      text: dueDate,
                      fontSize: 11,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: _priorityColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _priorityColor.withValues(alpha: 0.5)),
            ),
            child: CustomText(
              text: priority,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _priorityColor,
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            color: const Color(0xFF1F1F1F),
            offset: const Offset(0, 42),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    CustomText(
                      text: 'Editar',
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 16),
                    SizedBox(width: 8),
                    CustomText(
                      text: 'Eliminar',
                      fontSize: 13,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              }
              if (value == 'delete') {
                onDelete();
              }
            },
            icon: const Icon(Icons.more_vert, color: Colors.white70, size: 18),
          ),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    super.key,
    required this.initialValue,
    required this.label,
    required this.hintText,
    required this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
    this.maxLines = 1,
  });

  final String initialValue;
  final String label;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? suffixIcon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: _TasksScreenState._inputDecoration(label).copyWith(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: label,
              fontSize: 11,
              color: Colors.white54,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: value,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
