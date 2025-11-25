import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  final Map<String, dynamic> user;
  const CalendarPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calendário da Turma',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Visualize todas as atividades, provas e apresentações futuras'),
            const SizedBox(height: 16),
            
            // Filtros
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('Atividades'),
                  selected: true,
                  onSelected: (selected) {},
                ),
                FilterChip(
                  label: const Text('Avaliações'),
                  selected: true,
                  onSelected: (selected) {},
                ),
                FilterChip(
                  label: const Text('Apresentações'),
                  selected: true,
                  onSelected: (selected) {},
                ),
                FilterChip(
                  label: const Text('Tarefas Pessoais'),
                  selected: true,
                  onSelected: (selected) {},
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Calendário placeholder
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Calendário em Desenvolvimento',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Próximas atividades
            const Text(
              '3 próximas atividades',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Lista de atividades placeholder
            ...List.generate(3, (index) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.event),
                title: Text('Atividade ${index + 1}'),
                subtitle: const Text('Descrição da atividade'),
                trailing: const Text('01/01/2025'),
              ),
            )),
          ],
        ),
      ),
    );
  }
}