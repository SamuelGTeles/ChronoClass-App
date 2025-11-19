import 'package:flutter/material.dart';
import 'database_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Usuário')),
            TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await DatabaseHelper.instance.register(
                  usernameController.text.trim(),
                  passwordController.text.trim(),
                );
                setState(() {
                  message = success
                      ? 'Usuário criado com sucesso!'
                      : 'Usuário já existe!';
                });
              },
              child: const Text('Cadastrar'),
            ),
            const SizedBox(height: 12),
            Text(message),
          ],
        ),
      ),
    );
  }
}
