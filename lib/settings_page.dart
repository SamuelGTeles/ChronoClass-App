import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final Map<String, dynamic> user;
  const SettingsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Configurações', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Usuário: ${user['username']}'),
            Text('Tipo: ${user['role']}'),
          ],
        ),
      ),
    );
  }
}