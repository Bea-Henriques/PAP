import 'package:doit_app/widgets/custom_label.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:doit_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: openProjectForm, // create a project
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void openProjectForm() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                  children: [
                    CustomText(text: 'Novo Projeto', fontSize: 24),
                    SizedBox(height: 8),
                    CustomLabel(text: 'Nome'),
                    SizedBox(height: 8),
                    CustomTextfield(
                      controller: _nameController, 
                      hintText: 'Nome do projeto', 
                      prefixIcon: Icons.text_fields,
                    ),
                    SizedBox(height: 8),
                    CustomLabel(text: 'Descrição (opcional)'),
                    SizedBox(height: 8),
                    CustomTextfield(
                      controller: _descriptionController, 
                      hintText: 'Descrição do projeto', 
                      prefixIcon: Icons.description,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Column(
                          children: [
                            CustomLabel(text: 'Prazo'),
                            // DateTimePicker
                          ],
                        ),
                        SizedBox(width: 150),
                        Column(
                          children: [
                            CustomLabel(text: 'Estado'),
                            // Select
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
            ),
          ),
        );
      },
    );
  }
}