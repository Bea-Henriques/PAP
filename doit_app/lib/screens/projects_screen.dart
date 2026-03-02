import 'package:flutter/material.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
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
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                title: const Text('Projeto 1'),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 4),
                    Text('Descrição do projeto'),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Row(children: [
                          Icon(Icons.calendar_month_outlined),
                          SizedBox(width: 8,),
                          Text('Dia/Mês/Ano'),
                        ],),
                        SizedBox(width: 8,),
                        Chip(label: Text('Estado')),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ),
      );
  }
}