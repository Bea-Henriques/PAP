import 'package:doit_app/app_constants.dart';
import 'package:doit_app/models/task_model.dart';
import 'package:doit_app/services/tasks_services.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final TasksService _tasksService = TasksService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // O StreamBuilder é o pai de tudo para garantir que o layout 
      // acompanhe os dados vindos do Firebase
      body: StreamBuilder<List<TaskModel>>(
        stream: _tasksService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allTasks = snapshot.data ?? [];
          
          // Filtro: Apenas tarefas de hoje
          final now = DateTime.now();
          final todayString = "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
          final todayTasks = allTasks.where((t) => t.dueDate == todayString).toList();

          final completedCount = todayTasks.where((t) => t.completed).length;
          final totalCount = todayTasks.length;
          final double progressPercent = totalCount > 0 ? completedCount / totalCount : 0.0;

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
              children: [
                // --- CABEÇALHO FIXO ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        CustomText(text: "Today's Focus", fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                        SizedBox(height: 4),
                        CustomText(text: 'Your absolute priorities for today.', fontSize: 13, color: Color(0xFF8A8F9F)),
                      ],
                    ),
                    // Widget de Data
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white12)),
                      child: Column(
                        children: const [
                          CustomText(text: 'JUN', fontSize: 10, fontWeight: FontWeight.w700, color: AppConstants.brandPurple),
                          CustomText(text: '17', fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // --- BARRA DE PROGRESSO ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppConstants.brandPurple.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(18), border: Border.all(color: AppConstants.brandPurple.withValues(alpha: 0.15))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: 'Daily Progress', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                          CustomText(text: '$completedCount of $totalCount tasks', fontSize: 13, fontWeight: FontWeight.w600, color: AppConstants.brandPurple),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(value: progressPercent, backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation(AppConstants.brandPurple), minHeight: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- LISTA DE TAREFAS ---
                const _SectionLabel(title: 'Today\'s Tasklist', subtitle: 'To be cleared'),
                const SizedBox(height: 12),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todayTasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final task = todayTasks[index];
                    final priorityColor = task.priority == 'High' ? const Color(0xFFFF5B5B) : (task.priority == 'Medium' ? const Color(0xFFFFB44C) : const Color(0xFF2FAE8F));
                    
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.02), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _tasksService.toggleTask(task.id, !task.completed),
                            child: Icon(task.completed ? Icons.check_circle_rounded : Icons.radio_button_off_rounded, color: task.completed ? AppConstants.brandPurple : const Color(0xFF8A8F9F), size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(task.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: task.completed ? Colors.white38 : Colors.white, decoration: task.completed ? TextDecoration.lineThrough : null)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: priorityColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                            child: CustomText(text: task.priority, fontSize: 10, fontWeight: FontWeight.w600, color: priorityColor),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: title, fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        const SizedBox(height: 4),
        CustomText(text: subtitle, fontSize: 11, color: const Color(0xFF8A8F9F)),
      ],
    );
  }
}