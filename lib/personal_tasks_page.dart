import 'package:flutter/material.dart';

class PersonalTasksPage extends StatelessWidget {
  final Map<String, dynamic> user;
  const PersonalTasksPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tarefas Pessoais', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Usuário: ${user['username']}'),
            Text('Tipo: ${user['role']}'),
          ],
        ),
      ),
    );
  }
}