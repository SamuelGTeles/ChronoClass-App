import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_page.dart';
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

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF7A6592);
    const Color backgroundColor = Color(0xFFE9DEF0);

    return Scaffold(
      backgroundColor: backgroundColor,
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
                    color: Color.fromRGBO(0, 0, 0, 0.05))
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.book, size: 80, color: primaryColor),
                const SizedBox(height: 16),
                Text('Bem-vindo ao Chrono Class!',
                    style: GoogleFonts.poppins(
                        fontSize: 22, fontWeight: FontWeight.w600)),
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
                      icon: Icon(showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => showPassword = !showPassword),
                    ),
                  ),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final user = usernameController.text.trim();
                    final pass = passwordController.text.trim();

                    bool success =
                        await DatabaseHelper.instance.login(user, pass);
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    } else {
                      setState(
                          () => errorMessage = 'Usuário ou senha incorretos');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Entrar',
                      style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterPage()));
                  },
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
