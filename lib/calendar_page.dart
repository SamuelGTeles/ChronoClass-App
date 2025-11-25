import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  final Map<String, dynamic> user;
  const CalendarPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Calendário da Turma', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Usuário: ${user['username']}'),
            Text('Tipo: ${user['role']}'),
          ],
        ),
      ),
    );
  }
}