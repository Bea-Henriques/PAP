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
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

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
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  void openProjectForm() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
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
                    SizedBox(height: 14),
                    CustomLabel(text: 'Descrição (opcional)'),
                    SizedBox(height: 8),
                    CustomTextfield(
                      controller: _descriptionController, 
                      hintText: 'Descrição do projeto', 
                      prefixIcon: Icons.description,
                    ),
                    SizedBox(height: 14),
                    Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CustomLabel(text: 'Data de Início'),
                                CustomTextfield(
                                  controller: _startDateController, 
                                  hintText: 'DD-MM-AAAA', 
                                  prefixIcon: Icons.calendar_today_outlined,
                                  readOnly: true,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CustomLabel(text: 'Prazo'),
                                CustomTextfield(
                                  controller: _dueDateController, 
                                  hintText: 'DD-MM-AAAA', 
                                  prefixIcon: Icons.calendar_today_outlined,
                                  readOnly: true,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Column(
                        children: [
                          CustomLabel(text: 'Estado'),
                          // DateTimePicker
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