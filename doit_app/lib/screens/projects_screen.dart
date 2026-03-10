import 'package:doit_app/models/project_model.dart';
import 'package:doit_app/widgets/custom_button.dart';
import 'package:doit_app/widgets/custom_label.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:doit_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final List<String> _states = ['Planeado', 'Em Andamento', 'Concluído'];
  final List<String> _priorities = ['Baixa', 'Média', 'Alta'];
  final Color _formAccentColor = Colors.blue;
  String _selectedState = 'Planeado';
  String _selectedPriority = 'Baixa';
  final List<Project> _projects = [];

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Dismissible(
                key: UniqueKey(), 
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.delete),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      openProjectForm(); // open project details or edit form
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: 'Título do Projeto', fontSize: 16),
                          const SizedBox(height: 6),
                          CustomText(text: 'Descrição do projeto', fontSize: 14, color: Colors.blueGrey),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CustomText(text: 'Estado', fontSize: 12),
                              const SizedBox(width: 12),
                              CustomText(text: 'Prioridade', fontSize: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ),
            ],
          ),
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

  Future<void> pickDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    required Color accentColor,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down_rounded, color: accentColor),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
      style: TextStyle(
        color: Colors.blueGrey[800],
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: accentColor),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void openProjectForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                                    onTap: () => pickDate(_startDateController),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CustomLabel(text: 'Data de Conclusão'),
                                  CustomTextfield(
                                    controller: _dueDateController,
                                    hintText: 'DD-MM-AAAA',
                                    prefixIcon: Icons.calendar_today_outlined,
                                    readOnly: true,
                                    onTap: () => pickDate(_dueDateController),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CustomLabel(text: 'Estado'),
                                  SizedBox(height: 8),
                                  _buildDropdownField(
                                    value: _selectedState,
                                    items: _states,
                                    icon: Icons.flag_outlined,
                                    accentColor: _formAccentColor,
                                    onChanged: (String? newValue) {
                                      if (newValue == null) {
                                        return;
                                      }

                                      setModalState(() {
                                        _selectedState = newValue;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CustomLabel(text: 'Prioridade'),
                                  SizedBox(height: 8),
                                  _buildDropdownField(
                                    value: _selectedPriority,
                                    items: _priorities,
                                    icon: Icons.keyboard_double_arrow_up_rounded,
                                    accentColor: _formAccentColor,
                                    onChanged: (String? newValue) {
                                      if (newValue == null) {
                                        return;
                                      }

                                      setModalState(() {
                                        _selectedPriority = newValue;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: CustomButton(
                            onPressed: () {},
                            text: 'Adicionar',
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
