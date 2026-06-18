import 'package:flutter/material.dart';
import 'package:doit_app/app_constants.dart';
import 'package:doit_app/models/task_model.dart';
import 'package:doit_app/widgets/custom_text.dart';

class TaskForm {
  static Future<void> show({
    required BuildContext context,
    required Future<void> Function(TaskModel task) onCreate,
    required Future<void> Function(TaskModel task)? onUpdate,
    TaskModel? existingTask,
    Future<String?> Function()? pickDueDate,
  }) async {
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
                    CustomText(
                      text: isEditing ? 'Edit Task' : 'New Task',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),

                    const CustomText(
                      text: 'Task Name',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(),
                    ),

                    const SizedBox(height: 16),

                    const CustomText(
                      text: 'Description',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      controller: descriptionController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      decoration: _inputDecoration(),
                    ),

                    const SizedBox(height: 16),

                    InkWell(
                      onTap: () async {
                        final selected =
                            await (pickDueDate?.call());

                        if (selected != null) {
                          setSheetState(() {
                            chosenDueDate = selected;
                          });
                        }
                      },
                      child: _dateBox(chosenDueDate),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: ['Low', 'Medium', 'High'].map((p) {
                        final isSelected = selectedPriority == p;

                        final Color color = p == 'High'
                            ? const Color(0xFFFF5B5B)
                            : p == 'Medium'
                                ? const Color(0xFFFFB44C)
                                : const Color(0xFF2FAE8F);

                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setSheetState(() => selectedPriority = p),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.withValues(alpha: 0.15)
                                    : Colors.white.withValues(alpha: 0.02),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? color
                                      : Colors.white12,
                                ),
                              ),
                              child: Center(
                                child: CustomText(
                                  text: p,
                                  fontSize: 13,
                                  fontWeight:
                                      isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color:
                                      isSelected ? color : Colors.white60,
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

                        final task = TaskModel(
                          id: existingTask?.id ?? '',
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          dueDate: chosenDueDate,
                          priority: selectedPriority,
                          completed: existingTask?.completed ?? false,
                        );

                        if (isEditing && onUpdate != null) {
                          await onUpdate(task);
                        } else {
                          await onCreate(task);
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

  static InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.02),
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
        borderSide: const BorderSide(color: AppConstants.brandPurple),
      ),
    );
  }

  static Widget _dateBox(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_rounded,
              size: 16, color: Colors.white54),
          const SizedBox(width: 12),
          CustomText(
            text: date,
            fontSize: 14,
            color: date == 'No deadline'
                ? Colors.white38
                : AppConstants.brandPurple,
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 12, color: Colors.white24),
        ],
      ),
    );
  }
}