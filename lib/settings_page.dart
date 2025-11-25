import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const SettingsPage({super.key, required this.user});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    if (widget.user['role'] == 'admin' || widget.user['role'] == 'leader') {
      _loadUsers();
    }
  }

  Future<void> _loadUsers() async {
    try {
      final usersList = await DatabaseHelper.instance.getUsers();
      setState(() {
        users = usersList;
      });
    } catch (e) {
      print('Erro ao carregar usuários: $e');
    }
  }

  Future<void> _updateUserRole(int userId, String newRole) async {
    try {
      await DatabaseHelper.instance.updateUserRole(userId, newRole);
      _loadUsers();
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
    }
  }

  void _showUserManagementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gerenciar Usuários'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['username']),
                subtitle: Text('Tipo atual: ${_getRoleName(user['role'])}'),
                trailing: DropdownButton<String>(
                  value: user['role'],
                  onChanged: widget.user['role'] == 'admin' || 
                            (widget.user['role'] == 'leader' && user['role'] != 'admin')
                      ? (newRole) {
                          if (newRole != null) {
                            _updateUserRole(user['id'], newRole);
                          }
                        }
                      : null,
                  items: [
                    if (widget.user['role'] == 'admin') 
                      const DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                    if (widget.user['role'] == 'admin' || widget.user['role'] == 'leader')
                      const DropdownMenuItem(value: 'leader', child: Text('Liderança')),
                    const DropdownMenuItem(value: 'monitor', child: Text('Monitor')),
                    const DropdownMenuItem(value: 'student', child: Text('Aluno')),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  String _getRoleName(String role) {
    switch (role) {
      case 'admin': return 'Administrador';
      case 'leader': return 'Liderança';
      case 'monitor': return 'Monitor';
      case 'student': return 'Aluno';
      default: return 'Desconhecido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Configurações'),
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configurações de Conta',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Informações do usuário
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informações do Usuário',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Usuário'),
                            subtitle: Text(widget.user['username']),
                          ),
                          ListTile(
                            leading: const Icon(Icons.security),
                            title: const Text('Tipo de Usuário'),
                            subtitle: Text(_getRoleName(widget.user['role'])),
                          ),
                          ListTile(
                            leading: const Icon(Icons.group),
                            title: const Text('Turma'),
                            subtitle: Text(widget.user['class_team'] ?? 'Redes de Computadores II'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Gerenciamento de usuários (apenas para admin e liderança)
                  if (widget.user['role'] == 'admin' || widget.user['role'] == 'leader')
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gerenciamento de Usuários',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text('Gerencie os tipos de usuário e privilégios dos membros da turma.'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _showUserManagementDialog,
                              child: const Text('Gerenciar Usuários'),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Ações
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ações',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.exit_to_app),
                            title: const Text('Sair'),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}