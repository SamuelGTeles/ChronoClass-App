import 'package:flutter/material.dart';
import 'home_page.dart';
import 'database_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  String? errorMessage;

  void _showRegisterDialog() {
    String username = '';
    String password = '';
    String confirmPassword = '';
    String role = 'student';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Cadastro'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Usuário'),
                    onChanged: (value) => username = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    onChanged: (value) => password = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                    obscureText: true,
                    onChanged: (value) => confirmPassword = value,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: role,
                    items: const [
                      DropdownMenuItem(value: 'student', child: Text('Aluno')),
                      DropdownMenuItem(value: 'monitor', child: Text('Monitor')),
                    ],
                    onChanged: (value) => setState(() => role = value!),
                    decoration: const InputDecoration(labelText: 'Tipo de Usuário'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('As senhas não coincidem')),
                      );
                      return;
                    }

                    if (username.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Preencha todos os campos')),
                      );
                      return;
                    }

                    bool success = await DatabaseHelper.instance.register(username, password, role);
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Usuário criado com sucesso!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro ao criar usuário. Tente outro nome.')),
                      );
                    }
                  },
                  child: const Text('Cadastrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9DEF0),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 16,
                  offset: Offset(6, 6),
                  color: Color.fromRGBO(0, 0, 0, 0.05)
                )
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.book, size: 80, color: Color(0xFF7A6592)),
                const SizedBox(height: 16),
                const Text(
                  'Bem-vindo ao Chrono Class!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Usuário'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => showPassword = !showPassword),
                    ),
                  ),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final user = usernameController.text.trim();
                    final pass = passwordController.text.trim();

                    if (user.isEmpty || pass.isEmpty) {
                      setState(() => errorMessage = 'Preencha todos os campos');
                      return;
                    }

                    final userData = await DatabaseHelper.instance.login(user, pass);
                    if (userData != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(user: userData)),
                      );
                    } else {
                      setState(() => errorMessage = 'Usuário ou senha incorretos');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A6592),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: _showRegisterDialog,
                  child: const Text('Não tem cadastro? Cadastre-se!'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}