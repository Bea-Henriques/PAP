import 'package:doit_app/app_constants.dart';
import 'package:doit_app/models/project_model.dart';
import 'package:doit_app/services/projects_services.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class EditProjectScreen extends StatefulWidget {
  const EditProjectScreen({
    super.key,
    required this.project
  });

    final ProjectModel project;

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _dateController;

  final projectsService = ProjectsService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _descController = TextEditingController(text: widget.project.description);
    _dateController = TextEditingController(text: widget.project.dueDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _dateController.dispose();
    super.dispose();
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const CustomText(text: 'Edit Project', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFFF5B5B)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xFF13151A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text(
                        'Delete Project',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      content: const Text(
                        'Are you sure you want to delete this project? This action cannot be undone.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xFF8A8F9F)),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await ProjectsService().deleteProject(widget.project.id);

                            if (context.mounted) {
                              projectsService.deleteProject(widget.project.id);
                              Navigator.pop(context);   
                              Navigator.pop(context);  
                              Navigator.pop(context);  
                            }
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Color(0xFFFF5B5B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const CustomText(text: 'Project Title', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.03),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
              ),
            ),
            const SizedBox(height: 20),
            const CustomText(text: 'Description', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.03),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
              ),
            ),
            const SizedBox(height: 20),
            const CustomText(text: 'Due Date', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.03),
                suffixIcon: const Icon(Icons.calendar_today_rounded, color: Colors.white54, size: 18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async{
                if (_titleController.text.trim().isEmpty) return;
                await projectsService.updateProject(ProjectModel(
                  id: widget.project.id,
                  title: _titleController.text.trim(),
                  description: _descController.text.trim(),
                  dueDate: _dateController.text.trim(),
                  progress: widget.project.progress,
                  colorValue: widget.project.colorValue,
                ));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.brandPurple,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const CustomText(text: 'Save Changes', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}